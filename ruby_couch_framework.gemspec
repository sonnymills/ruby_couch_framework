Gem::Specification.new do |s|
  s.name        = 'ruby_couch_framework'
  s.version     = '0.0.0'
  s.date        = '2018-01-10'
  s.summary     = "kill rails with couch"
  s.description = "kill moar rails with couch and less kitchen-sink"
  s.authors     = ["Emerson Mills"]
  s.email       = 'mrsn@odd-e.com'
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_paths = ["lib"]

  s.extra_rdoc_files = [
    "LICENSE",
    "README",
  ]
  s.license       = 'MIT'
end
