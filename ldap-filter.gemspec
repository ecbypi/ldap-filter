# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ldap/filter/version"

Gem::Specification.new do |s|
  s.name        = "ldap-filter"
  s.version     = LDAP::Filter::VERSION
  s.authors     = ["Eduardo Gutierrez"]
  s.email       = ["edd_d@mit.edu"]
  s.homepage    = ""
  s.summary     = %q{DSL for building LDAP filters}
  s.description = %q{DSL for dynamically building LDAP filters}

  s.rubyforge_project = "ldap-filter"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
end
