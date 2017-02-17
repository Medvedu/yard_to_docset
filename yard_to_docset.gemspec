# encoding: utf-8
Gem::Specification.new do |spec|
  spec.name          = "yard_to_docset"
  spec.version       = "0.1.0"
  spec.authors       = ["Kuzichev Michael"]
  spec.email         = ["kMedvedu@gmail.com"]
  spec.description   = "Converts rdoc/yard documentation to a Dash Docset"
  spec.summary       = "Rdoc/Yard to Dash Docset Converter"
  #spec.homepage      = "https://rubygems.org/gems/yard_to_dash"

  spec.require_paths = ["lib"]

  spec.files         = `git ls-files`.split($/)
  spec.test_files    = Dir['spec/**/*.rb']

  spec.executables  << 'yard_to_docset'

  spec.add_dependency "rake"
  spec.add_dependency "yard"
end
