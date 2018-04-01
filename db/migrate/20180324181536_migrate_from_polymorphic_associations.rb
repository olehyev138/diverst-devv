class MigrateFromPolymorphicAssociations < ActiveRecord::Migration
  def up
    # list of polymorphic associations
    # budget, checklist, checklist_item, field, folder, folder_share, graph
    # user_reward_actions, tag, resource, news_feed_link_segment, news_feed_link
    
    # add foreign_keys to maintain relationships
    add_reference :tags, :resource
    
    add_reference :budgets, :event
    add_reference :budgets, :group
    
    add_reference :checklists, :budget
    add_reference :checklists, :initiative
    
    # migrate existing polymorphic associations to new structure
    Tag.where(:taggable_type => "Resource").update_all("resource_id = taggable_id")
    
    # budget for events/groups
    Budget.where(:subject_type => "Event").update_all("event_id = subject_id")
    Budget.where(:subject_type => "Group").update_all("group_id = subject_id")
    
    # checklists for budgets/initiatives
    Checklist.where(:subject_type => "Budget").update_all("budget_id = subject_id")
    Checklist.where(:subject_type => "Initiative").update_all("initiative_id = subject_id")
    
    # remove polymorphic fields
    remove_reference :tags,       :taggable,  polymorphic: true
    remove_reference :budgets,    :subject,   polymorphic: true
    remove_reference :checklists, :subject,   polymorphic: true
  end
  
  def down
    add_reference :tags,       :taggable,  polymorphic: true
    add_reference :budgets,    :subject,   polymorphic: true
    add_reference :checklists, :subject,   polymorphic: true
    
    # migrate foreign keys back to polymorphic associations
    Tag.where.not(:resource_id => nil).update_all("taggable_id = resource_id, taggable_type = 'Resource'")
    
    # budget for events/groups
    Budget.where.not(:event_id => nil).update_all("subject_id = event_id, subject_type = 'Event'")
    Budget.where.not(:group_id => nil).update_all("subject_id = group_id, subject_type = 'Group'")
    
    # checklists for budgets/initiatives
    Checklist.where.not(:budget_id => nil).update_all("subject_id = budget_id, subject_type = 'Budget'")
    Checklist.where.not(:initiative_id => nil).update_all("subject_id = initiative_id, subject_type = 'Initiative'")

    remove_reference :tags,     :resource
    
    remove_reference :budgets,  :event
    remove_reference :budgets,  :group
    
    remove_reference :checklists,  :budget
    remove_reference :checklists,  :initiative
  end
end
