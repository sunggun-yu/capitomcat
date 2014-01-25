require 'rake'
require 'capistrano/all'
require 'capistrano/setup'
require 'capistrano/deploy'

class Application

  def self.doCap

    set :stage, :dev

    set :format, :pretty
    set :log_level, :info
    set :pty, true
    set :use_sudo, true

    # Server definition section
    role :app, %w{deploy@dev01 deploy@dev02}

    # Remote Tomcat server setting section
    set :tomcat_user, 'tomcat7'
    set :tomcat_user_group, 'tomcat7'
    set :tomcat_port, '8080'
    set :tomcat_cmd, '/etc/init.d/tomcat7'
    set :use_tomcat_user_cmd, false
    set :tomcat_war_file, '/var/app/war/test-web.war'
    set :tomcat_context_path, '/test-web'
    set :tomcat_context_file, '/var/lib/tomcat7/conf/Catalina/localhost/test-web.xml'
    set :tomcat_work_dir, '/var/lib/tomcat7/work/Catalina/localhost/test-web'

    # Deploy setting section
    set :local_war_file, '/tmp/test-web.war'
    set :context_template_file, File.expand_path('../../../templates/context.xml.erb', __FILE__).to_s
    set :use_parallel, false
    set :use_context_update, false

    capistrano = Capistrano::Application.new
    require 'capitomcat'
    capistrano.invoke('capitomcat:deploy')
  end

  def self.do_customized_cap

    set :stage, :dev

    set :format, :pretty
    set :log_level, :info
    set :pty, true
    set :use_sudo, true

    # Server definition section
    role :app, %w{deploy@dev01 deploy@dev02}

    # Remote Tomcat server setting section
    set :tomcat_user, 'tomcat7'
    set :tomcat_user_group, 'tomcat7'
    set :tomcat_port, '8080'
    set :tomcat_cmd, '/etc/init.d/tomcat7'
    set :use_tomcat_user_cmd, false
    set :tomcat_war_file, '/var/app/war/test-web.war'
    set :tomcat_context_path, '/test-web'
    set :tomcat_context_file, '/var/lib/tomcat7/conf/Catalina/localhost/test-web.xml'
    set :tomcat_work_dir, '/var/lib/tomcat7/work/Catalina/localhost/test-web'

    # Deploy setting section
    set :local_war_file, '/tmp/test-web.war'
    set :context_template_file, File.expand_path('../../../templates/context.xml.erb', __FILE__).to_s
    set :use_parallel, false

    capistrano = Capistrano::Application.new
    Rake.application.add_import('../lib/native/tasks/tomcat_webapp.cap')
    Rake.application.load_imports
    capistrano.invoke('tomcat:deploy')
  end
end