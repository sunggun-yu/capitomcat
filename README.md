# Capitomcat
[![Gem Version](https://badge.fury.io/rb/capitomcat.png)](http://badge.fury.io/rb/capitomcat)

Capitomcat is library for creating Capistrano Tomcat recipe.
Capitomcat includes basic tasks for Tomcat deployment. You can create easily your own Capistrano 3 recipe for Tomcat with Capitomcat.

##See Also
### Capitomcat Jenkins Plugin
* Home page : https://wiki.jenkins-ci.org/display/JENKINS/Capitomcat+Plugin
* Source Repo: https://github.com/jenkinsci/capitomcat-plugin

##Requirement
###Gem Dependency
* Ruby >= 1.9
* Capistrano >= 3.0.1

### Authentication & Authorisation setting for Remote Servers
By the recommendation of Capistrano 3, Capitomcat use SSH Key and NOPASSWD instead of asking password.

for more details, please refer to  [Authentication & Authorisation][1] page on Capistrano website.
[1]: http://capistranorb.com/documentation/getting-started/authentication-and-authorisation/
####User account setting
```` sh
root@remote $ adduser <your_deploy_user_name>
root@remote $ passwd -l <your_deploy_user_name>
````
or
```` sh
root@remote $ adduser --home /home/deploy --disabled-password deploy
````

####SSH Key setting
Add your SSH key into `authorized_keys` file of `deploy` user on your remote server.

####NOPASSWD Setting for SUDO
Folowing NOPASSWD setting is required. please add following setting into your `/etc/sudoers` file.
```` sh
%your_deploy_user_name ALL=NOPASSWD:/etc/init.d/tomcat7 <Your tomcat command>
%your_deploy_user_name ALL=NOPASSWD: /bin/chown 
%your_deploy_user_name ALL=(<your_tomcat_user> : <your_tomcat_user_group>) NOPASSWD: ALL
````

##Installation
To use Capitomcat in your Capistrano script, you need install as RubyGem

###Install Ruby
Please refer to [Download Ruby](http://www.ruby-lang.org/en/downloads/) page on the Ruby official website.
###Install RubyGems
Please refer to [Download RubyGems](http://rubygems.org/pages/download) page on the RubyGems official website.
###Install Capistrano
Capitomcat v1.0.0 supports Capistrano 3. (Capitomcat v0.0.x supports Capistrano 2)
``` sh
$ gem install capistrano -v 3.0.1
```
###Install Capitomcat
``` sh
$ gem install capitomcat
```	

##Configuration
### Role Configuration
<pre>
role :app, %w{deploy@dev01 deploy@dev02}
</pre>
### Required configuration for Capitomcat
<pre>
set :use_sudo, true

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
set :tomcat_cmd_wait_start, 10 # Second
set :tomcat_cmd_wait_stop, 5 # Second
set :use_background_tomcat_cmd, false # Use normal execute command as default

# Deploy setting section
set :local_war_file, '/tmp/test-web.war'
set :context_template_file, File.expand_path('../templates/context.xml.erb', __FILE__).to_s
set :use_context_update, false
set :use_parallel, false
set :use_context_update, false
</pre>

###Task
You can get task name of Capitomcat by run `cap -T`
<pre>
cap capitomcat:deploy              # Capitomcat Recipe for Tomcat web application deployment
</pre>

###***Documentation is still working on...***

&hearts;For more details, please refer to example recipes.&hearts;

## License
<pre>
Copyright 2014 Sunggun Yu

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</pre>