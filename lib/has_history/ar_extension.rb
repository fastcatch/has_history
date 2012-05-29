module HasHistory
  module ClassMethods

    #
    # put has_history in your model class and your changes will be saved
    #
    #   available options: see initializer
    #
    def has_history(*args)
      options = args.extract_options!
      has_many :history_entries, :class_name => 'HistoryEntry', :as => :entity, :dependent => :destroy
      after_update Proc.new{|record| HasHistory::History.create(record, options)}
    end
  end
  ActiveRecord::Base.extend(ClassMethods)
end
