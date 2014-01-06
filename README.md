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
``` sh
$ gem install capistrano -v 3.0.1
```
###Install Capitomcat
``` sh
$ gem install capitomcat
```	

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