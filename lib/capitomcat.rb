# Author:: Sunggun Yu

configuration = Capistrano::Configuration.respond_to?(:instance) ?
  Capistrano::Configuration.instance(:must_exist) :
  Capistrano.configuration(:must_exist)

configuration.load do

  default_run_options[:pty] = true
  default_run_options[:shell] = '/bin/sh'

  set :tmp_dir, "/tmp"

  desc "Capistrano Recipe for Tomcat"
  namespace :capitomcat do
    desc "Stop Tomcat"
    task :stop, :roles => :app do
      run "#{sudo :as => tomcat_cmd_user} #{remote_tomcat_cmd} stop", :pty => true
    end

    desc "Start Tomcat"
    task :start, :roles => :app do
      run "echo `nohup #{sudo :as => tomcat_cmd_user} #{remote_tomcat_cmd} start&` && sleep 1", :pty => true
      run("for i in {0..180}; do echo \"Waiting for Tomcat to start\"; if [ \"\" != \"$\(netstat -an | grep #{tomcat_port}\)\" ]; then break; fi; sleep 30; done")
      run("netstat -an | grep #{tomcat_port}")
    end

    desc "Upload WAR file"
    task :uploadWar, :roles => :app do
      set(:war_file_name) { File.basename(remote_docBase) }
      set :tmp_war_file, "#{tmp_dir}/#{war_file_name}"
      # Clean remote file before upload
      remove_file_if_exist('root', tmp_war_file)
      # Upload WAR file to temp dir
      upload(local_war_file, tmp_war_file, :via => :scp, :pty => true)
      begin
        # Change uploaded WAR file's owner
        run "#{sudo :as => 'root'} chown #{tomcat_user}:#{tomcat_user} #{tmp_war_file}"
        # Move tmp WAR fiel to actual path
        run "#{sudo :as => tomcat_user} cp #{tmp_war_file} #{remote_docBase}", :mode => 0644
        # Clean remote file after task finished
        remove_file_if_exist('root', tmp_war_file)
      rescue
        run "#{sudo :as => 'root'} rm #{tmp_war_file}"
      end
    end

    desc "Update and upload context file"
    task :updateContext, :roles => :app do
      set(:context_file_name) { File.basename(remote_context_file) }
      set :tmp_context_file, "#{tmp_dir}/#{context_file_name}"
      # Clean remote file before upload
      remove_file_if_exist('root', tmp_context_file)
      # Generate context file from template and upload to temp dir on the remote server
      generate_config(context_template_file, tmp_context_file)
      begin
        # Change uploaded context file's owner
        run "#{sudo :as => 'root'} chown #{tomcat_user}:#{tomcat_user} #{tmp_context_file}"
        # Move tmp WAR fiel to actual path
        run "#{sudo :as => tomcat_user} cp #{tmp_context_file} #{remote_context_file}", :mode => 0644
        # Clean remote file after task finished
        remove_file_if_exist('root', tmp_context_file)
      rescue
        run "#{sudo :as => 'root'} rm #{tmp_context_file}"
      end
    end

    desc "Cleaning-up Tomcat work directory"
    task :cleanWorkDir, :roles => :app do
      set :remote_tomcat_work_dir, "#{remote_tomcat_work_dir}"
      run "#{sudo :as => tomcat_user} rm -rf #{remote_tomcat_work_dir}"
    end
  end

  # Copy context.xml template to remote server
  def parse_config(file)
    require 'erb'
    template=File.read(file)
    return ERB.new(template).result(binding)
  end

  # Generate config file from erb template
  def generate_config(local_file,remote_file)
    temp_file = '/tmp/' + File.basename(local_file)
    buffer    = parse_config(local_file)
    File.open(temp_file, 'w+') { |f| f << buffer }
    upload temp_file, remote_file, :via => :scp
    `rm #{temp_file}`
  end

  # Remove file if exist
  def remove_file_if_exist exc_user, file
    run "if [ -e #{file} ]; then #{sudo :as => exc_user} rm -f #{file}; fi"
  end
end

# Excute multiple task by serial
def serial_task(&block)
  original = ENV['HOSTS']
  find_servers_for_task(self.current_task).each do |server|
    ENV['HOSTS'] = server.host
    yield
  end
ensure
  ENV['HOSTS'] = original
end