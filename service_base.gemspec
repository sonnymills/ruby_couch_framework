Gem::Specification.new do |s|
  s.name        = 'service_base'
  s.version     = '0.0.20'
  s.date        = '2018-01-10'
  s.summary     = "kill rails with couch"
  s.description = "kill moar rails with couch and less kitchen-sink"
  s.authors     = ["Emerson Mills","Aimee Furber"]
  s.email       = 'mrsn@odd-e.com'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]
  s.add_development_dependency "rspec", "~> 3.7"
  s.add_runtime_dependency "couchrest",[ "~> 2.0"]
  s.add_runtime_dependency "bcrypt", ["~> 3.1"]

  s.extra_rdoc_files = [
    "LICENSE",
    "README",
  ]
  s.license       = 'MIT'
end
