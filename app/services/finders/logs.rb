class Finders::Logs
  attr_reader :logs

  def initialize(logs)
    @logs = logs
  end

  def filter_by_groups(group_ids)
    group_ids = format_in_clause(group_ids.reject(&:blank?))
    return self if group_ids.blank?

    logs = @logs
      .joins("LEFT JOIN initiatives ON activities.trackable_type = 'Initiative' \
                AND activities.trackable_id = initiatives.id")
      .joins('LEFT JOIN initiative_groups ON initiative_groups.initiative_id = initiatives.id')
      .joins("LEFT JOIN groups_polls ON activities.trackable_type = 'Poll' \
                AND activities.trackable_id = groups_polls.poll_id")
      .joins("LEFT JOIN user_groups ON activities.trackable_type = 'User' \
                AND activities.trackable_id = user_groups.user_id")
      .where("initiatives.owner_group_id IN (#{group_ids}) \
                OR initiative_groups.group_id IN (#{group_ids}) \
                OR groups_polls.group_id IN (#{group_ids}) \
                OR user_groups.group_id IN (#{group_ids}) \
                OR (activities.trackable_type = 'Group' AND activities.trackable_id IN (#{group_ids}))")
    Finders::Logs.new(logs)
  end

  private

  def format_in_clause(array)
    array.collect { |e| "'#{e}'" }.join(', ')
  end
end
