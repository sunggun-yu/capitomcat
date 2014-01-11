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

    if File.exists?(local_war_file)
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
    else
      error("Local WAR file does not existing. : #{local_war_file}")
      exit(1)
    end
  end

  # Generate context.xml file string from ERB template file and bindings
  def get_context_template
    # local variables
    context_template_file = fetch(:context_template_file)

    if ! File.exists?(context_template_file)
      error('Context template file does not existing.')
      exit(1)
    end

    # local variables for erb file
    tomcat_context_path = fetch(:tomcat_context_path)
    tomcat_war_file = fetch(:tomcat_war_file)
    info ("#{tomcat_context_path}, #{tomcat_war_file}" )

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

    if test "[ -d #{tomcat_work_dir} ]"
      within(tomcat_work_dir) do
        execute :sudo, '- u', tomcat_user, 'rm -rf', tomcat_work_dir
      end
    else
      warn('Tomcat work directory does not existing.')
    end
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

  # Change owner and move file
  # @param [String] file
  # @param [String] destination file name with its path
  # @param [String] user
  # @param [String] group
  def change_owner_and_move (file, destination, user, group)
    # Change file's owner
    puts user
    execute :sudo, :chown, "#{user}:#{group}", file

    # Move file to destination
    target_dir = File.dirname(destination)
    if test "[ -d #{target_dir} ]"
      within target_dir do
        execute :sudo, '-u', user, :mv, '-f', file, destination
      end
    else
      warn("Target directory is not existing. Capitomcat will try mkdir for target directory. : #{target_dir}")
      execute :sudo, '-u', user, :mkdir, '-p', target_dir
      within(target_dir) do
        execute :sudo, '-u', user, :mv, '-f', file, destination
      end
    end
  end

  # Remove file if exist
  # @param [String] user
  # @param [String] file
  def remove_file_if_exist (user, file)
    if test "[ -e #{file} ]"
      execute :sudo, :chown, user, file
      execute :rm, '-f', file
    else
      warn('Target file to remove is not existing.')
    end
  end
end