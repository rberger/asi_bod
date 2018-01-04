
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "asi_bod/version"

Gem::Specification.new do |spec|
  spec.name          = "asi_bod"
  spec.version       = AsiBod::VERSION
  spec.authors       = ["Robert J. Berger"]
  spec.email         = ["rberger@ibd.com"]

  spec.summary       = %q{Process and View Grin Phaserunner ASIObjectDictionary.xml and BOD.json files}
  spec.description   = %q{Process and View Grin Phaserunner ASIObjectDictionary.xml and BOD.json files}
  spec.homepage      = "https://github.com/rberger/asi_bod"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "aruba", "~> 0.14"
  spec.add_runtime_dependency "gli","~> 2.17"
  spec.add_runtime_dependency "nori","~> 2.6"

end
