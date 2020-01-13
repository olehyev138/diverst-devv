# Module to include Models which defines Fields, containing needed functions
module DefinesFields
  extend ActiveSupport::Concern

  # Calls the function +ContainsFieldData::create_missing_field_data(*ids)+ on all its field_users
  #
  # @author Alex Oxorn
  # @param *ids [Array<Integer>] (optional) ids to check
  # @return [void]
  def create_missing_field_data(*ids)
    self.class.field_users.each do |f_users|
      send(f_users).find_each do |f_usr|
        f_usr.create_missing_field_data(*ids)
      end
    end
  end

  # Create a background job which calls +DefinesFields::create_missing_field_data(field.id)+
  #
  # @author Alex Oxorn
  # @param field [Field] field to add +field_data+ for
  # @return [void]
  def add_missing_field_background_job(field)
    UpdateMissingFieldDataJob.perform_later(model_name.name, id, field.id) if id.present?
  end
end
