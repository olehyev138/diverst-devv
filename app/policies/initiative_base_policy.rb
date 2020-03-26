class InitiativeBasePolicy < GroupBasePolicy
  attr_accessor :initiative, :initiative_user

  def initialize(user, context, params = {})
    case user
    when InitiativePolicy
      @user = user.user
      @initiative = user.record
      @group = @initiative.group
      @record = context
      @params = user.params
      @group_leader_role_id = user.group_leader_role_id
      @policy_group = user.policy_group
      @group_leader = user.group_leader
      @user_group = user.user_group
    else
      @user = user
      @record = record
      @params = params
      @policy_group = @user.policy_group

      # Check if it's a collection, a record, or a class
      if context.is_a?(Enumerable) # Collection/Enumerable
        self.initiative = context.first
        self.record = context.second
      elsif context.is_a?(Class) # Class
        # Set group using params if context is a class as this will be for
        # nested model actions such as index and create, which require a group
        self.initiative = Initiative.find(params[:initiative_id] || params.dig(context.model_name.param_key.to_sym, :initiative_id)) rescue nil
      elsif context.present?
        self.initiative = context.initiative
        self.record = context
      end

      self.group = initiative&.group

      if initiative
        @initiative_user = user.policy_initiative_user(initiative.id)
      end
      if group
        @group_leader = user.policy_group_leader(group.id)
        @user_group = user.policy_user_group(group.id)
      end
    end
  end

  def is_creator?
    initiative.owner_id == user.id
  end

  def is_attending?
    initiative_user.present?
  end

  def is_a_member?
    super || (user.group_ids && participating_group_ids).present?
  end

  class Scope < Scope
    def group_has_permission(permission)
      GroupLeader.attribute_names.include?(permission)
    end

    delegate :index?, to: :policy
    delegate :group, to: :policy
    delegate :initiative, to: :policy

    def group_base
      group.send(scope.all.klass.model_name.collection)
    end

    def initiative_base
      initiative.send(scope.all.klass.model_name.collection)
    end

    def resolve(permission)
      if initiative
        if index?
          initiative_base.merge(scope)
        else
          scope.none
        end
      else
        super(permission)
      end
    end
  end
end
