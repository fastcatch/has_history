# -*- encoding: utf-8 -*-
require File.expand_path('../lib/has_history/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["fastcatch"]
  gem.email         = ["andras.zimmer@gmail.com"]
  gem.description   = %q{Adds history to ActiveRecord models.}
  gem.summary       = %q{Add has_history to your ActiveRecord model and you'll instantly have access to the full history of changes of the record.}
  gem.homepage      = "https://github.com/fastcatch/has_history"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "has_history"
  gem.require_paths = ["lib"]
  gem.version       = HasHistory::VERSION
end
