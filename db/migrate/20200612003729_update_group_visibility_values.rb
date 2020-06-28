class UpdateGroupVisibilityValues < ActiveRecord::Migration[5.2]
  def update_visibility(visibility_value)
    ##
    # Visibility values must be public, group or leaders_only
    #   - Convert global -> public
    #   - Convert managers_only -> leaders_only
    #   - Set to default of leaders_only if not one of 3 valid values - ie nil
    #

    if [ 'public', 'group', 'leaders_only' ].include? visibility_value
      visibility_value
    elsif visibility_value == 'global'
      'public'
    elsif visibility_value == 'managers_only'
      'leaders_only'
    else
      'leaders_only'
    end
  end

  def up
    # Update group visibility settings based on pr 2209 - https://github.com/TeamDiverst/diverst-development/pull/2209/files
    #  - other visibility values are non problematic on legacy db migrations & have not been updated in beta

    transaction do
      Group.find_each do |group|
        group.members_visibility = members_visibility = update_visibility(group.members_visibility)
        group.event_attendance_visibility = event_attendance_visibility = update_visibility(group.event_attendance_visibility)
        group.messages_visibility = update_visibility(group.messages_visibility)

        group.save!(validate: false)
      rescue => e
        abort(e.message)
      end
    end
  end

  def down
    # Empty down - impossible to revert, but dont raise irreversible so we dont block rollbacks
  end
end
