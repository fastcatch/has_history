require 'active_record'
require 'lib/has_history'
Dir['test/app/models/*.rb'].each { |f| require f }
require 'test/unit'

class ActiveSupport::TestCase

  ActiveRecord::Base.establish_connection(
    :adapter => "sqlite3",
    :database => ":memory:"
  )
  load 'test/db/schema.rb'
  
end
