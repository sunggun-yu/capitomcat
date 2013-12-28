# -*- encoding: utf-8 -*-

# Author:: Sunggun Yu

$:.push File.expand_path("lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "capitomcat"
  s.version     = "0.0.3"

  s.authors     = ["Sunggun Yu"]
  s.email       = ["sunggun.dev@gmail.com"]
  s.licenses    = ['Apache 2.0']
  s.date        = %q{2013-12-27} 
  s.homepage    = "http://sunggun-yu.github.io/capitomcat/"
  s.summary     = %q{Capistrano Recipe for Tomcat}
  s.description = %q{You can deploy your war file to multiple remote tomcat servers through this Capistrano recipe.}

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency('capistrano')
  s.add_development_dependency('rake')
end