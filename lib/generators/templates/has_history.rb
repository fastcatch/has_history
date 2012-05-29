# Array of attributes whose changes do not need to be saved to history
# Defaults to [:updated_at, :updater_id, :created_at, :creator_id, :updated_on, :created_on]
# HasHistory::History.ignore_attributes = [:updated_at, :updater_id, :created_at, :creator_id, :updated_on, :created_on]

# Determines the id(!) of the user who made the change
#   if it is a symbol or a string, it is sent to the record (e.g. :updated_by)
#   if it is a proc, it gets called with the record as a param (e.g. Proc.new{ User.current_user })
# Defaults to :updated_by
# HasHistory::History.updater_id = :updated_by

# Hash map to resolve foreign keys (in the form of :attribute_id => :value_method)
#   changes in keys will save values from the referenced entity
#   :value_method is sent to the referenced entity to fetch value to store
#   e.g. { :user_id => :full_name, :post_id => :title
# Defaults to {}
# HasHistory::History.resolution_map = {}
