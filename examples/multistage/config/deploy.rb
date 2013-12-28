# Author:: Sunggun Yu

require 'capitomcat'

desc "Release Task for myjob"
namespace :myapp do
  task :release, :roles => :app do
    serial_task do
      capitomcat.uploadWar
      capitomcat.stop
      capitomcat.updateContext
      capitomcat.cleanWorkDir
      capitomcat.start
    end
  end
end