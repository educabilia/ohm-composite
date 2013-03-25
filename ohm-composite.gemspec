require File.expand_path("lib/ohm/composite", File.dirname(__FILE__))

Gem::Specification.new do |s|
  s.name              = "ohm-composite"
  s.version           = Ohm::Composite::VERSION
  s.summary           = "Composite (regular and unique) indices for Ohm."
  s.authors           = ["Educabilia", "Damian Janowski"]
  s.email             = ["opensource@educabilia.com", "djanowski@dimaion.com"]
  s.homepage          = "https://github.com/educabilia/ohm-composite"

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {test}/*`.split("\n")
end
