# encoding: utf-8
Gem::Specification.new do |s|
  s.name          = "yard_to_docset"
  s.version       = "0.5.0"
  s.authors       = ["Kuzichev Michael"]
  s.licenses      = ["MIT"]
  s.email         = ["kMedvedu@gmail.com"]
  s.description   = "Converts Yard documentation to a Dash Docset"
  s.summary       = "Yard to Dash Docset Converter"
  s.homepage      = "https://github.com/Medvedu/yard_to_docset"
  s.require_paths = ["lib"]
  s.executables  << 'yard_to_docset'
  s.files         = `git ls-files`.split($/)
  s.test_files    = Dir['spec/**/*.rb']

  s.required_ruby_version = '>= 2.1.0'

  s.add_dependency 'rake'
  s.add_dependency "yard",        "~> 0.9.8",   ">= 0.9.8"
  s.add_dependency "sqlite3",     "~> 1.3.13",  ">= 1.3.13"
  s.add_dependency "nokogiri",    "~> 1.7.0.1", ">= 1.7.0"
end
