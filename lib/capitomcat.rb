require 'capistrano'

# Author:: Sunggun Yu

# Capistrano library for Capitomcat Recipe'
namespace :capitomcat do

  # Start Tomcat server
  def start_tomcat
    # local variables
    tomcat_cmd = fetch(:tomcat_cmd)

    puts capture(:sudo, get_sudo_user_tomcat_cmd, "#{tomcat_cmd} start")
  end

  # Check status whether started
  def check_tomcat_started
    # local variables
    tomcat_port = fetch(:tomcat_port)

    execute "for i in {0..180}; do echo \"Waiting for Tomcat to start\"; if [ \"\" != \"$(netstat -an | grep #{tomcat_port})\" ]; then break; fi; sleep 30; done"
    puts capture("netstat -an | grep #{tomcat_port}")
  end

  # Stop Tomcat server
  def stop_tomcat
    # local variables
    tomcat_cmd = fetch(:tomcat_cmd)

    puts capture(:sudo, get_sudo_user_tomcat_cmd, "#{tomcat_cmd} stop")
  end

  # Upload the WAR file
  def upload_war_file
    # local variables
    upload_user = fetch(:user)
    local_war_file = fetch(:local_war_file)
    tomcat_war_file = fetch(:tomcat_war_file)
    tomcat_user = fetch(:tomcat_user)
    tomcat_user_group = fetch(:tomcat_user_group)

    # Setup file name
    temp_dir = Pathname.new('/tmp')
    temp_file = File.basename(tomcat_war_file)
    tmp_war_file = temp_dir.join(temp_file)

    # Clean remote file before uploading
    remove_file_if_exist(upload_user, tmp_war_file)
    # Upload WAR file into temp dir
    upload! local_war_file, tmp_war_file
    # Move tmp WAR file to actual path
    change_owner_and_move(tmp_war_file, tomcat_war_file, tomcat_user, tomcat_user_group)
  end

  # Generate context.xml file string from ERB template file and bindings
  def get_context_template
    # local variables
    context_template_file = fetch(:context_template_file)

    # local variables for erb file
    tomcat_context_name = fetch(:tomcat_context_name)
    tomcat_war_file = fetch(:tomcat_war_file)
    info ("#{tomcat_context_name}, #{tomcat_war_file}" )

    template_file = File.read(File.expand_path(context_template_file, __FILE__))
    template = ERB.new(template_file)
    return template.result(binding)
  end

  # Upload context template string to remote server
  def upload_context_file
    # local variables
    upload_user = fetch(:user)
    tomcat_context_file = fetch(:tomcat_context_file)
    tomcat_user = fetch(:tomcat_user)
    tomcat_user_group = fetch(:tomcat_user_group)
    context_template = get_context_template

    temp_upload_file = '/tmp/' + File.basename(tomcat_context_file)
    remove_file_if_exist upload_user, temp_upload_file
    contents = StringIO.new(context_template)
    upload! contents, temp_upload_file
    change_owner_and_move(temp_upload_file, tomcat_context_file, tomcat_user, tomcat_user_group)
  end

  # Clean-up work directory
  def cleanup_work_dir
    # local variables
    tomcat_work_dir = fetch(:tomcat_work_dir)
    tomcat_user = fetch(:tomcat_user)

    execute "if [ -e #{tomcat_work_dir} ]; then sudo -u #{tomcat_user} rm -rf #{tomcat_work_dir}; fi"
  end

  # Get Parallelism
  # @return :parallel or :sequence
  def get_parallelism
    if fetch(:use_parallel) == true then
      return :parallel
    else
      return :sequence
    end
  end

  # Get sudo user for tomcat command
  # @return -u and sudo user name for tomcat command. if :use_tomcat_user_cmd is false, it will return '-u root'
  def get_sudo_user_tomcat_cmd
    if fetch(:use_tomcat_user_cmd) == true then
      return "-u #{fetch(:tomcat_user)}"
    else
      return '-u root'
    end
  end

  # Move file and change owner
  # @param [String] file
  # @param [String] destination
  # @param [String] user
  # @param [String] group
  def move_and_change_owner (file, destination, user, group)
    # Move tmp WAR file to actual path
    execute :mv, '-f', file, destination
    # Change uploaded WAR file's owner
    execute :sudo, :chown, "#{user}:#{group}", destination
  end

  # Change owner and move file
  # @param [String] file
  # @param [String] destination
  # @param [String] user
  # @param [String] group
  def change_owner_and_move (file, destination, user, group)
    # Change uploaded WAR file's owner
    execute :sudo, :chown, "#{user}:#{group}", file
    # Move tmp WAR file to actual path
    execute :sudo, '-u', user, :mv, '-f', file, destination
  end

  # Remove file if exist
  # @param [String] user
  # @param [String] file
  def remove_file_if_exist (user, file)
    execute "if [ -e #{file} ]; then sudo chown #{user} #{file} ; rm -f #{file}; fi"
  end
end