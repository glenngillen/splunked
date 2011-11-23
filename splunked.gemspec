# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "splunked/version"

Gem::Specification.new do |s|
  s.name        = "splunked"
  s.version     = Splunked::VERSION
  s.authors     = ["Glenn Gillen"]
  s.email       = ["me@glenngillen.com"]
  s.homepage    = ""
  s.summary     = %q{Easy searching of logs in Splunk}
  s.description = %q{Provides a simple way to extract and aggregate log data in Splunk}

  s.rubyforge_project = "splunked"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "rest-client", "~> 1.6.7"
  s.add_runtime_dependency "nokogiri", "~> 1.5.0"
  s.add_runtime_dependency "chronic_duration", "~> 0.8.0"
end
