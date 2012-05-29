class Post < ActiveRecord::Base
  belongs_to :user
  has_history :updater_id => Proc.new{-1},     # we don't have authentication for the test so fake it
              :resolution_map => {:user_id => :name}
end
