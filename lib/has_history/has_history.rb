module HasHistory

  class History
    CONFIGURABLES = [:ignore_attributes, :updater_id, :resolution_map]

    if respond_to?(:class_attribute)
      class_attribute *CONFIGURABLES
    else
      class_inheritable_accessor *CONFIGURABLES
    end

    self.ignore_attributes = [:updated_at, :updater_id, :created_at, :creator_id, :updated_on, :created_on]
    self.updater_id = :updated_by
    self.resolution_map = {}

    def initialize(options = {})
      @options = options
      # passed in values take precedence over config values over baked-in defaults
      CONFIGURABLES.each do |key|
        @options[key] ||= self.send( key)
      end
    end

    # Creates a new history entry (if needed)
    # class method
    def self.create(record, options)
      history = History.new(options)
      history.save(record)
    end

    # Check if entry has to be created and do it
    def save(record)
      changes = record.changes

      # some values obviously change but we don't care
      changes.delete_if {|key,value|  @options[:ignore_attributes].include? key.to_sym}

      # also remove keys for which AR reports changes but in fact there are none
      changes.delete_if {|key,value| value[0]==value[1]}

      # create history entry if meaningful
      if !changes.empty?
        HistoryEntry.create(
          :entity => record,
          :modified_by_id => updated_by(record),
          :modifications => format_for_history(record, changes)
        )
      end
    end

  private
    def format_for_history(record, changes)
      # replace "*_id" references with values
      formatted_changes = materialize_references(record, changes, @options[:resolution_map])

=begin
    # replace time and date values with display style values
    formatted_changes.each_pair do |key, values|
      attribute_type = (record.send key.to_sym).class.name
      if attribute_type =~ /Date|Time/
        old_value = values[0].present? ? I18n.l(values[0], :locale=>locale) : ""
        new_value = values[1].present? ? I18n.l(values[1], :locale=>locale) : ""
        formatted_changes[key] = [old_value, new_value]
      end
    end

    # more to come: process formatters
=end
      formatted_changes.collect do |ch|
        { ch[0] => {:before => ch[1][0], :after => ch[1][1]} }
      end
    end

    def materialize_references(record, changes, mapping)
      # replace "*_id" references with values with the provided mapping, leave other changes intact
      changes.inject({}) do |memo, change|
        resolution_attribute = mapping[change[0]] || mapping[change[0].to_sym]
        cleaned = resolution_attribute ? resolve_reference(record, change, resolution_attribute) : change
        memo.merge!({cleaned[0] => cleaned[1]})
      end
    end

    def resolve_reference(record, change, resolution_attribute)
      # record is an instance with the new values
      # change is an array of the format [key_with_id, [old_id, new_id]]
      # returns [old_value, new_value] by replacing references with resolution_attribute of the referenced entity
      # => e.g. (Activity, salesrep_id => [1,2], "full_name") returns ["salesrep", ["John Past", "Jerry Comes"]]
      # Please note that change should only contain one tuple!!!

      key, old_id, new_id = change.flatten
      attribute = key.to_s[0...-3]      # remove the "_id" part

      if new_id.present?
        dummy_record = record.clone
        dummy_record[key] = new_id
        new_value = dummy_record.send(attribute.to_sym).send(resolution_attribute.to_sym)
      else
        new_value = nil
      end

      # use AR to get the old value on a dummy duplicate
      if old_id.present?
        dummy_record = record.clone
        dummy_record[key] = old_id
        old_value = dummy_record.send(attribute.to_sym).send(resolution_attribute.to_sym)
      else
        old_value = nil
      end

      result = [attribute, [old_value, new_value]]
      result
    end

    # returns the id of the user that updated the record
    def updated_by(record)
      if @options[:updater_id].is_a?(Symbol) || @options[:updater_id].is_a?(String)
        record.send(@options[:updater_id].to_sym)
      elsif @options[:updater_id].is_a? Proc
        @options[:updater_id].call(record)
      end
    end

  end
end
