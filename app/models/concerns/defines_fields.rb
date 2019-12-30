module DefinesFields
  extend ActiveSupport::Concern

  def create_missing_field_data
    self.class.field_users.each do |f_users|
      send(f_users).find_each do |f_usr|
        f_usr.create_missing_field_data
      end
    end
  end
end
