# Capitomcat
[![Gem Version](https://badge.fury.io/rb/capitomcat.png)](http://badge.fury.io/rb/capitomcat)

Capitomcat is library for creating Capistrano Tomcat recipe.
Capitomcat includes basic tasks for Tomcat deployment. You can create easily your own Capistrano 3 recipe for Tomcat with Capitomcat.

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
You have to add the following options in your `Capfile` or `deploy.rb`
<pre>
role :app
set  :user
set  :password
set  :tomcat_user
set  :tomcat_cmd_user
set  :tomcat_port
set  :local_war_file
set  :context_template_file
set  :context_name`
set  :remote_docBase
set  :remote_context_file 
set  :remote_tomcat_cmd
set  :remote_tomcat_work_dir
set  :stages
</pre>
* `:app` - The application servers that you want to deploy
* `:user` - User name which is going to run Capistrano script.
* `:password` - Password of `:user`.
* `:tomcat_user` - The owner of Tomcat home directory.
* `:tomcat_cmd_user` - The user that runs tomcat scripts : ex) /etc/init.d/tomcat
* `:tomcat_port` - Port number of Tomcat server. this value is needed to check whether Tomcat process is running.
* `:local_war_file` - The WAR file which will upload to remote tomcat server.
* `:context_template_file` - Path for the template file in your local, which is application's Tomcat context. also, following ERB variable are should be included in the template file.
	* context.xml.erb
<pre>
&lt;Context path="/<%= context_name %>" docBase="<%= remote_docBase %>" /&gt;
</pre>
 * `<%= context_name %>` - This variable is for the ***path*** attribute in the context file. It will be replaced to `:context_name`
 * `<%= remote_docBase %>` - This variable is for the ***docBase*** attribute in the context file.It will be replaced to `:remote_docBase`
- `:context_name` - Root context name of application.
- `:remote_docBase` -  The pathname to the web application archive file (if this web application is being executed directly from the WAR file)
- `:remote_context_file` -  Application's context file path for Tomcat on your remote servers. basically, context file is located in `/your/tomcat/home/conf/Catalina/localhost/appname.xml`
- `:remote_tomcat_cmd` -  Tomcat's star, stop command. for example, `/etc/init.d/tomcat` or `/your/tomcat/home/bin/catalina.sh` can be used. please make sure not to include `start` or `stop` parameter.
- `:remote_tomcat_work_dir` - Tomcat work directory for application. this directory will be used at `capitomcat:cleanWorkDir` task

### Multistage setting
If you want to use Multistage deployment, You should add following option in your `Capfile` or `deploy.rb`
also, please refer to [Multistage Extension](https://github.com/capistrano/capistrano/wiki/2.x-Multistage-Extension).
- `:stages` -  
<pre>
# Application Stage Section
set :stages, %w(dev stg prod)
</pre>

### Examples
#### Single Stage
/your/capistrano/project/***Capfile***
```
require 'capitomcat'

# Application host section
role  :app, "dev01", "dev02"

# User section
set   :user, "stg"
set   :password, "password"
set   :tomcat_user, "tomcat"
set   :tomcat_cmd_user, "root"

# Local file section
set   :local_war_file, "/tmp/app.war"
set   :context_template_file, "./template/context.xml.erb"

# Remote setting section
set   :context_name, "app"
set   :remote_docBase, "/tmp/test/earl/war/abc.war"
set   :remote_context_file, "/tmp/test/tomcat/conf/Catalina/localhost/app.xml"
set   :remote_tomcat_cmd, "/tmp/test/etc/init.d/tomcat7"
set   :remote_tomcat_work_dir, "/opt/tomcat/work/Catalina/localhost/app"
```

#### Multi Stage
Project structure.
```
/ your/capistrano/project/
|-- config
|   |-- deploy
|   |   |-- dev.rb
|   |   |-- stg.rb
|   |   `-- prod.rb
|   `-- deploy.rb
`-- Capfile
```
Also, the file name under config/deploy are should be matched in  `set :stages`

* /your/capistrano/project/***Capfile***

  ```
  require 'capitomcat'
  require 'capistrano/ext/multistage'

  # Application Stage Section
  set :stages, %w(dev stg prod)

  # User section
  set   :user, "stg"
  set   :password, "password"
  set   :tomcat_user, "tomcat"
  set   :tomcat_cmd_user, "root"

  # Local file section
  set   :local_war_file, "/tmp/app.war"
  set   :context_template_file, "./template/context.xml.erb"

  # Remote setting section
  set   :context_name, "app"
  set   :remote_docBase, "/tmp/test/earl/war/abc.war"
  set   :remote_context_file, "/tmp/test/tomcat/conf/Catalina/localhost/app.xml"
  set   :remote_tomcat_cmd, "/tmp/test/etc/init.d/tomcat7"
  set   :remote_tomcat_work_dir, "/opt/tomcat/work/Catalina/localhost/app"
  ```

* /your/capistrano/project/***config/deploy/dev.rb***

  ```
  # Application host section for DEV
  role  :app, "dev-host-1", "dev-host-2"
  ```

*  /your/capistrano/project/***config/deploy/stg.rb***

  ```
  # Application host section for stg
  role  :app, "stg-host-1", "stg-host-2"
  ```

* /your/capistrano/project/***config/deploy/prod.rb***

  ```
  # Application host section for Production
   role  :app, "prod-host-1", "prod-host-2"
 ```

##Available Tasks
To get a list of all capistrano tasks, run `cap -T` with user password:
<pre>
cap capitomcat:cleanWorkDir  # Cleaning-up Tomcat work directory
cap capitomcat:start         # Start capitomcat.
cap capitomcat:stop          # Stop capitomcat.
cap capitomcat:updateContext # Update and upload context file
cap capitomcat:uploadWar     # Upload WAR file
</pre>

### capitomcat:cleanWorkDir
This Task will remove Application's Tomcat work directory. Please make sure you should start/restart Tomcat after this task has executed.
### capitomcat:start
This Task will start your Tomcat server using `:remote_tomcat_cmd` command.
If you have `set :remote_tomcat_cmd, '/etc/init.d/tomcat7'` and `set :tomcat_cmd_user, 'root'` in your Capfile or deploy.rb file then the Task will execute `sudo -p <:password> -u root /etc/init.d/tomcat7 start` commnad on your remote servers which are setted in `role :app`.
### capitomcat:stop
This Task will stop your Tomcat server using `:remote_tomcat_cmd` command.
If you have `set :remote_tomcat_cmd, '/user/local/tomcat7/bin/catalina.sh'` and `set :tomcat_cmd_user, 'tomcat'` in your Capfile or deploy.rb file then the Task will execute `sudo -p <:password> -u tomcat /user/local/tomcat7/bin/catalina.sh stop` commnad on your remote servers which are setted in `role :app`.
### capitomcat:updateContext
This Task will generate context file from your context template file. and Upload the generated context file to `:remote_context_file`
### capitomcat:uploadWar
This Task will upload the `:local_war_file` to `:remote_docBase` 

##Usage
To use capitomcat gem, You need to create your own Capistrano script.
You can create Capistrano project structure and default files from scratch to run `capify .`
```
$ mkdir -p /your/capistrano/project
$ cd /your/capistrano/project
$ capify .
$ tree

/ your/capistrano/project/
|-- config
|   `-- deploy.rb
`-- Capfile
```
add settings into your Capfile or deploy.rb file. and you can execute capitomcat recipe like this.
```
$ cap capitomcat:stop
```

Also, you can combine tasks as a one task by creating new task inside the your Capfile or deploy.rb file.
```
require 'capitomcat'

desc "Release Task for myjob"
namespace :myapp do
  task :release, :roles => :app do
    capitomcat.stop
    capitomcat.uploadWar
    capitomcat.updateContext
    capitomcat.cleanWorkDir
    capitomcat.start
  end
end
```

### Execute tasks serially
Capistrano performs the task parallel, So in the above case, if you have multiple server each task will be performed for each servers.
```
# host1, host2

stop ==> host1
stop ==> host2

uploadWar ==> host1
uploadWar ==> host2

...
```

if you do perform release like below, use serial_task function.
```
# host1, host2

stop ==> host1
uploadWar ==> host1
updateContext ==> host1
start ==> host1

stop ==> host2
uploadWar ==> host2
updateContext ==> host2
start ==> host2
```

```
require 'capitomcat'

desc "Release Task for myjob"
namespace :myapp do
  task :release, :roles => :app do
    serial_task do
      capitomcat.stop
      capitomcat.uploadWar
      capitomcat.updateContext
      capitomcat.cleanWorkDir
      capitomcat.start
    end
  end
end
```

### Perform multistage task
If you have multistage setting, you can perform the task as like below.
```
cap prod myapp:release
```

&hearts;For more details, please refer to example projects.&hearts;

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