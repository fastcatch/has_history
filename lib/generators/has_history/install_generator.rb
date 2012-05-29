# encoding: utf-8
module HasHistory
  class InstallGenerator < Rails::Generators::Base
    desc "Copies a config initializer to config/initializers/has_history.rb"

    source_root File.expand_path('../templates', __FILE__)

    def copy_files
      template        'has_history.rb', 'config/initializers/has_history.rb'
    end
  end
end
