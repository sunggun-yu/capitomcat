# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# set :deploy_to, '/var/www/my_app'
# set :scm, :git

# set :format, :pretty
# set :log_level, :debug
# set :pty, true

# set :linked_files, %w{config/database.yml}
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
# set :keep_releases, 5

# Capitomcat
require 'capitomcat'

set :format, :pretty
set :log_level, :info
set :pty, true
set :use_sudo, true

# Server definition section
role :app, %w{deploy@dev01 deploy@dev02}

# Remote Tomcat server setting section
set   :tomcat_user, 'tomcat7'
set   :tomcat_user_group, 'tomcat7'
set   :tomcat_port, '8080'
set   :tomcat_cmd, '/etc/init.d/tomcat7'
set   :use_tomcat_user_cmd, false
set   :tomcat_war_file, '/var/app/war/test-web.war'
set   :tomcat_context_name, 'test-web'
set   :tomcat_context_file, '/var/lib/tomcat7/conf/Catalina/localhost/test-web.xml'
set   :tomcat_work_dir, '/var/lib/tomcat7/work/Catalina/localhost/test-web'

# Deploy setting section
set   :local_war_file, '/tmp/test-web.war'
set   :context_template_file, '../../template/context.xml.erb'
set   :use_parallel, true

namespace :deploy do
  desc 'Starting Deployment'
  task :startRelease do
    on roles(:app), in: get_parallelism, wait: 5 do |hosts|
      info 'Upload WAR file'
      upload_war_file

      info 'Stop Tomcat'
      stop_tomcat

      info 'Update Context'
      upload_context_file

      info 'Clean Work directory'
      cleanup_work_dir

      info 'Start Tomcat'
      start_tomcat
      check_tomcat_started
    end
  end
end