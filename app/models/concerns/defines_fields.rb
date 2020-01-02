module DefinesFields
  extend ActiveSupport::Concern

  def create_missing_field_data(*ids)
    self.class.field_users.each do |f_users|
      send(f_users).find_each do |f_usr|
        f_usr.create_missing_field_data(*ids)
      end
    end
  end

  def add_missing_field_background_job(field)
    UpdateMissingFieldDataJob.perform_later(model_name.name, id, field.id) if id.present?
  end
end
