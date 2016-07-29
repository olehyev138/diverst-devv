class PolicyGroup < ActiveRecord::Base
  has_many :users
  belongs_to :enterprise

  accepts_nested_attributes_for :users

  def self.default_group(enterprise_id)
    default_group = self.where(enterprise_id: enterprise_id)
                        .where(default_for_enterprise: true)
                        .first

    return default_group if default_group.present?

    self.where(enterprise_id: enterprise_id).first
  end
end
