# -*- encoding: utf-8 -*-

# Author:: Sunggun Yu

$:.push File.expand_path('lib', __FILE__)

require_relative 'lib/capitomcat/version'

Gem::Specification.new do |s|
  s.name        = 'capitomcat'
  s.version     = Capitomcat::VERSION

  s.authors     = ['Sunggun Yu']
  s.email       = ['sunggun.dev@gmail.com']
  s.licenses    = ['Apache 2.0']
  s.date        = %q{2015-01-25}
  s.homepage    = 'http://sunggun-yu.github.io/capitomcat/'
  s.summary     = %q{Capistrano 3 recipe for Tomcat web application deployment}
  s.description = %q{Capitomcat is the Capistrano 3 recipe for Tomcat web application deployment.}

  s.files         = `git ls-files`.split("\n")
  s.require_paths = ["lib"]

  s.add_dependency 'capistrano', '~> 3.3', '>= 3.3.5'
end