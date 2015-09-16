class EmployeeSerializer < ActiveModel::Serializer
  attributes :id,
    :first_name,
    :last_name,
    :info

  # We create a hash with the fields' titles as keys and their value as value
  def info
    fields = object.enterprise.fields.select([:id, :title])
    brown = object.info.map do |k, v|
      field = fields.select{|field| field.id == k}[0]
      if field.nil? # If a field has been deleted from the database but is in the user's info hash, return nil. It will be exculded when we call compact! later.
        nil
      else
        [field.title, v]
      end
    end

    brown.compact! # LOL
    Hash[brown] # LOOOOL
  end
end
