# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require 'thor'
require "gsbb/version"

Gem::Specification.new do |s|
  s.name        = "gsbb"
  s.version     = Gsbb::VERSION
  s.authors     = ["Chris Apolzon"]
  s.email       = ["apolzon@gmail.com"]
  s.homepage    = "http://github.com/apolzon/gsbb"
  s.summary     = %q{Find and kill and blame those worthless stale branches}
  s.description = %q{Find and kill and blame those worthless stale branches}

  s.rubyforge_project = "gsbb"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_development_dependency "pry"
  s.add_development_dependency "mocha"
  s.add_dependency "thor"
  s.add_dependency "grit"
end
