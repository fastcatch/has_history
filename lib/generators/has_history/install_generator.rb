# encoding: utf-8
require 'rails/generators'
require 'rails/generators/migration'

module HasHistory
  class InstallGenerator < Rails::Generators::Base
    desc "Copies a config initializer to config/initializers/has_history.rb and creates a migration file"
    include Rails::Generators::Migration
    source_root File.expand_path('../../templates', __FILE__)

    def self.next_migration_number(path)
      Time.now.utc.strftime("%Y%m%d%H%M%S")
    end

    def copy_files
      migration_template  "create_history_entries.rb", "db/migrate/create_history_entries.rb"
      template            'has_history.rb', 'config/initializers/has_history.rb'
    end
  end
end
