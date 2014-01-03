require 'capistrano'

# Author:: Sunggun Yu

desc "Capistrano library for Capitomcat Recipe"
namespace :capitomcat do

  desc "Start Tomcat server"
  def startTomcat tomcat_command
    execute "echo `nohup sudo #{tomcat_command} start&` && sleep 1"
  end

  # Check status whether started
  def checkTomcatStarted tomcat_port
    execute "for i in {0..180}; do echo \"Waiting for Tomcat to start\"; if [ \"\" != \"$\(netstat -an | grep #{tomcat_port}\)\" ]; then break; fi; sleep 30; done"
    execute "netstat -an | grep #{tomcat_port}"
  end

  # Stop Tomcat server
  def stopTomcat tomcat_command
    execute :sudo, "#{tomcat_command} stop"
  end

  # Upload the WAR file
  def uploadWarFile upload_user, local_war_file, remote_docBase, tomcat_user, tomcat_user_group
    # Setup file name
    temp_dir = Pathname.new('/tmp')
    temp_file = File.basename(remote_docBase)
    tmp_war_file = temp_dir.join(temp_file)

    # Clean remote file before uploading
    remove_file_if_exist(upload_user, tmp_war_file)
    # Upload WAR file into temp dir
    upload! local_war_file, tmp_war_file
    # Move tmp WAR file to actual path
    moveAndChangeOwner(tmp_war_file, remote_docBase, tomcat_user, tomcat_user_group)
  end

  # Generate context.xml file string from ERB template file and bindings
  def getContextTemplate context_template_file, context_name, remote_docBase
    template_file = File.read(File.expand_path(context_template_file, __FILE__))
    context_name = context_name
    remote_docBase = remote_docBase
    template = ERB.new(template_file)
    return template.result(binding)
  end

  # Upload context template string to remote server
  def uploadContext upload_user, context_template, remote_context_file, tomcat_user, tomcat_user_group
    temp_upload_file = '/tmp/' + File.basename(remote_context_file)
    remove_file_if_exist upload_user, temp_upload_file
    contents = StringIO.new(context_template)
    upload! contents, temp_upload_file
    ChangeOwnerAndMove temp_upload_file, remote_context_file, tomcat_user, tomcat_user_group
  end

  # Clean-up tomcat's work directory
  def cleanWorkDir remote_tomcat_work_dir, tomcat_user
    execute "if [ -e #{remote_tomcat_work_dir} ]; then sudo -u #{tomcat_user} rm -rf #{remote_tomcat_work_dir}; fi"
  end

  # Move file and change owner

  def moveAndChangeOwner file, destination, user, group
    # Move tmp WAR fiel to actual path
    execute :mv, "-f", file, destination
    # Change uploaded WAR file's owner
    execute :sudo, :chown, "#{user}:#{group}", destination
  end

  # Change owner and move file

  def ChangeOwnerAndMove file, destination, user, group
    # Change uploaded WAR file's owner
    execute :sudo, :chown, "#{user}:#{group}", file
    # Move tmp WAR fiel to actual path
    execute :sudo, "-u", user, :mv, "-f", file, destination
  end

  # Remove file if exist

  def remove_file_if_exist user, file
    execute "if [ -e #{file} ]; then sudo chown #{user} #{file} ; rm -f #{file}; fi"
  end
end