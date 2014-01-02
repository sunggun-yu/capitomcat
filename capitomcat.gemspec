# -*- encoding: utf-8 -*-

# Author:: Sunggun Yu

$:.push File.expand_path("lib", __FILE__)

Gem::Specification.new do |s|
  s.name        = "capitomcat"
  s.version     = "0.1.0"

  s.authors     = ["Sunggun Yu"]
  s.email       = ["sunggun.dev@gmail.com"]
  s.licenses    = ['Apache 2.0']
  s.date        = %q{2014-01-01} 
  s.homepage    = "http://sunggun-yu.github.io/capitomcat/"
  s.summary     = %q{Capistrano library for Capistrano 3 Tomcat Recipe}
  s.description = %q{Capitomcat is the library that supports basic task for Tomcat deployment. You can create your own Capistrano 3 recipe for tomcat using with Capitomcat.}

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency "capistrano", "~> 3.0.1"
  s.add_dependency "capistrano-bundler"
end