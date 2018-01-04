class PolicyGroup < ActiveRecord::Base

    has_many :users
    belongs_to :enterprise

    validates :name,        presence: true
    validates :enterprise,  presence: true
    
    attr_accessor :new_users
    
    accepts_nested_attributes_for :users

    before_save :remove_default_from_other_groups, if: :default_group?
    before_create :force_default, unless: Proc.new { |pg| pg.enterprise.policy_groups.exists? }

    #Before destroying default group make sure we set other as default
    before_destroy :mark_other_pg_as_default, if: :default_group?

    def default_group?
        default_for_enterprise
    end

    def self.default_group(enterprise_id)
        selected_default_group = self.all_default_groups(enterprise_id).first

        # If there is deducated default group
        if selected_default_group
            self.all_default_groups(enterprise_id).first
        else # Just return first group of enterprise to ensure no errors will arise
            self.all_groups_of_enterprise(enterprise_id).first
        end
    end

    def self.users_that_able_to_accept_budgets(enterprise)
        enterprise.users.select { |u| u.policy_group.budget_approval }
    end

    def allow_deletion?
        return false if default_group?
        return false if users.count > 0

        true
    end

    private

    # Helper method. There should be only one default group at every moment.
    # This method only deducated to ensuring this
    def self.all_default_groups(enterprise_id)
        all_groups_of_enterprise(enterprise_id)
            .where(default_for_enterprise: true)
    end

    def self.all_groups_of_enterprise(enterprise_id)
        self.where(enterprise_id: enterprise_id)
    end

    def all_default_groups
        self.class.all_default_groups(enterprise.id)
    end

    def remove_default_from_other_groups
        other_defaults = all_default_groups
            .where.not(id: id)

        other_defaults.each do |policy_group|
            policy_group.update_column(:default_for_enterprise, false)
        end
    end

    def force_default
        self.default_for_enterprise = true
    end

    def mark_other_pg_as_default
        other_default = self.enterprise.policy_groups
            .where.not(id: id)
            .first
        # IMPROVEMENT this will prevent last group from deletion, but needs error message
        return false if other_default.nil?

        other_default.update(default_for_enterprise: true)
    end
end
