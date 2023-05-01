# frozen_string_literal: true

require_relative "lib/memereply/api/error/version"

Gem::Specification.new do |spec|
  spec.name          = "marr" # Memereply Api Rescue Response aka marr
  spec.version       = Memereply::Api::Error::VERSION
  spec.authors       = ["Memereply", "Micah Bowie"]
  spec.email         = ["engineering@memereply.io"]

  spec.summary       = "Dynamically rescue errors and render a structured JSON response to client applications"
  spec.description   = "Dynamically rescue errors and render a structured JSON response to client applications"
  spec.homepage      = "https://github.com/meme-reply/sad_pepe"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/meme-reply/sad_pepe"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"

  spec.add_dependency "activesupport", " >= 6.0"
end
