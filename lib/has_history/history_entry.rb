class HistoryEntry < ActiveRecord::Base
  belongs_to :entity, :polymorphic => true

  # modifications is an array of changes, each member is of the format:
  #   { attribute => {:before => value_before, :after => value_after} }
  serialize :modifications

  validates_presence_of :entity, :modified_by_id
end
