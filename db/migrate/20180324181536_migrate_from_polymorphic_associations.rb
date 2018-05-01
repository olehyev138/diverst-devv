class MigrateFromPolymorphicAssociations < ActiveRecord::Migration
  def up
    # list of polymorphic associations
    # tags, budget, checklist, checklist_item, field, folder, folder_share, graph
    # user_reward_actions, resource, news_feed_link_segment, news_feed_link
    
    # add foreign_keys to maintain relationships
    add_reference :tags, :resource
    
    add_reference :budgets, :event
    add_reference :budgets, :group
    
    add_reference :checklists, :budget
    add_reference :checklists, :initiative
    
    add_reference :checklist_items, :initiative
    add_reference :checklist_items, :checklist
    
    add_reference :fields, :enterprise
    add_reference :fields, :event
    add_reference :fields, :group
    add_reference :fields, :poll
    add_reference :fields, :initiative
    
    add_reference :folders, :enterprise
    add_reference :folders, :group
    
    add_reference :folder_shares, :enterprise
    add_reference :folder_shares, :group
    
    add_reference :graphs, :metrics_dashboard
    add_reference :graphs, :poll
    
    add_reference :user_reward_actions, :initiative
    add_reference :user_reward_actions, :initiative_comment
    add_reference :user_reward_actions, :group_message
    add_reference :user_reward_actions, :group_message_comment
    add_reference :user_reward_actions, :news_link
    add_reference :user_reward_actions, :news_link_comment
    add_reference :user_reward_actions, :social_link
    add_reference :user_reward_actions, :answer_comment
    add_reference :user_reward_actions, :answer_upvote
    add_reference :user_reward_actions, :answer
    add_reference :user_reward_actions, :poll_response
    
    add_reference :resources, :enterprise
    add_reference :resources, :folder
    add_reference :resources, :group
    add_reference :resources, :initiative
    
    add_reference :news_feed_links, :news_link
    add_reference :news_feed_links, :group_message
    add_reference :news_feed_links, :social_link
    
    # migrate existing polymorphic associations to new structure
    Tag.where(:taggable_type => "Resource").update_all("resource_id = taggable_id")
    
    # budget for events/groups
    Budget.where(:subject_type => "Event").update_all("event_id = subject_id")
    Budget.where(:subject_type => "Group").update_all("group_id = subject_id")
    
    # checklists for budgets/initiatives
    Checklist.where(:subject_type => "Budget").update_all("budget_id = subject_id")
    Checklist.where(:subject_type => "Initiative").update_all("initiative_id = subject_id")
    
    # checklist_items for initiatives
    ChecklistItem.where(:container_type => "Initiative").update_all("initiative_id = container_id")
    ChecklistItem.where(:container_type => "Checklist").update_all("checklist_id = container_id")
    
    # fields for enterprises, events, groups, polls, initiatives
    Field.where(:container_type => "Enterprise").update_all("enterprise_id = container_id")
    Field.where(:container_type => "Event").update_all("event_id = container_id")
    Field.where(:container_type => "Group").update_all("group_id = container_id")
    Field.where(:container_type => "Poll").update_all("poll_id = container_id")
    Field.where(:container_type => "Initiative").update_all("initiative_id = container_id")
    
    # folders for enterprises and groups
    Folder.where(:container_type => "Enterprise").update_all("enterprise_id = container_id")
    Folder.where(:container_type => "Group").update_all("group_id = container_id")
    
    # folder_shares for enterprises and groups
    FolderShare.where(:container_type => "Enterprise").update_all("enterprise_id = container_id")
    FolderShare.where(:container_type => "Group").update_all("group_id = container_id")
    
    # graphs for polls and metric_dashboards
    Graph.where(:collection_type => "MetricsDashboard").update_all("metrics_dashboard_id = collection_id")
    Graph.where(:collection_type => "Poll").update_all("poll_id = collection_id")
    
    # user_reward_actions for initiatives, etc
    UserRewardAction.where(:entity_type => "MetricsDashboard").update_all("initiative_id = entity_id")
    UserRewardAction.where(:entity_type => "InitiativeComment").update_all("initiative_comment_id = entity_id")
    UserRewardAction.where(:entity_type => "GroupMessage").update_all("group_message_id = entity_id")
    UserRewardAction.where(:entity_type => "GroupMessageComment").update_all("group_message_comment_id = entity_id")
    UserRewardAction.where(:entity_type => "NewsLink").update_all("news_link_id = entity_id")
    UserRewardAction.where(:entity_type => "NewsLinkComment").update_all("news_link_comment_id = entity_id")
    UserRewardAction.where(:entity_type => "SocialLink").update_all("social_link_id = entity_id")
    UserRewardAction.where(:entity_type => "AnswerComment").update_all("answer_comment_id = entity_id")
    UserRewardAction.where(:entity_type => "AnswerUpvote").update_all("answer_upvote_id = entity_id")
    UserRewardAction.where(:entity_type => "Answer").update_all("answer_id = entity_id")
    UserRewardAction.where(:entity_type => "PollResponse").update_all("poll_response_id = entity_id")
    
    # resources for enterprises, folders, initiatives, groups
    Resource.where(:container_type => "Enterprise").update_all("enterprise_id = container_id")
    Resource.where(:container_type => "Folder").update_all("folder_id = container_id")
    Resource.where(:container_type => "Group").update_all("group_id = container_id")
    Resource.where(:container_type => "Initiative").update_all("initiative_id = container_id")
    
    # news_feed_link for news_links, group_messages, social_links
    NewsFeedLink.where(:link_type => "NewsLink").update_all("news_link_id = link_id")
    NewsFeedLink.where(:link_type => "GroupMessage").update_all("group_message_id = link_id")
    NewsFeedLink.where(:link_type => "SocialLink").update_all("social_link_id = link_id")
    
    # remove polymorphic fields
    remove_reference :tags,                 :taggable,    polymorphic: true
    remove_reference :budgets,              :subject,     polymorphic: true
    remove_reference :checklists,           :subject,     polymorphic: true
    remove_reference :checklist_items,      :container,   polymorphic: true
    remove_reference :fields,               :container,   polymorphic: true
    remove_reference :folders,              :container,   polymorphic: true
    remove_reference :folder_shares,        :container,   polymorphic: true
    remove_reference :graphs,               :collection,  polymorphic: true
    remove_reference :user_reward_actions,  :entity,      polymorphic: true
    remove_reference :resources,            :container,   polymorphic: true
    remove_reference :news_feed_links,      :link,        polymorphic: true
  end
  
  def down
    add_reference :tags,                :taggable,    polymorphic: true
    add_reference :budgets,             :subject,     polymorphic: true
    add_reference :checklists,          :subject,     polymorphic: true
    add_reference :checklist_items,     :container,   polymorphic: true
    add_reference :fields,              :container,   polymorphic: true
    add_reference :folders,             :container,   polymorphic: true
    add_reference :folder_shares,       :container,   polymorphic: true
    add_reference :graphs,              :collection,  polymorphic: true
    add_reference :user_reward_actions, :entity,      polymorphic: true
    add_reference :resources,           :container,   polymorphic: true
    add_reference :news_feed_links,     :link,        polymorphic: true
    
    # migrate foreign keys back to polymorphic associations
    Tag.where.not(:resource_id => nil).update_all("taggable_id = resource_id, taggable_type = 'Resource'")
    
    # budget for events/groups
    Budget.where.not(:event_id => nil).update_all("subject_id = event_id, subject_type = 'Event'")
    Budget.where.not(:group_id => nil).update_all("subject_id = group_id, subject_type = 'Group'")
    
    # checklists for budgets/initiatives
    Checklist.where.not(:budget_id => nil).update_all("subject_id = budget_id, subject_type = 'Budget'")
    Checklist.where.not(:initiative_id => nil).update_all("subject_id = initiative_id, subject_type = 'Initiative'")

    # checklist_items for initiatives/Checklist
    ChecklistItem.where.not(:initiative_id => nil).update_all("container_id = initiative_id, container_type = 'Initiative'")
    ChecklistItem.where.not(:checklist_id => nil).update_all("container_id = checklist_id, container_type = 'Checklist'")
    
    # fields for enterprises, events, groups, polls, initiatives
    Field.where.not(:enterprise_id => nil).update_all("container_id = enterprise_id, container_type = 'Enterprise'")
    Field.where.not(:event_id => nil).update_all("container_id = event_id, container_type = 'Event'")
    Field.where.not(:group_id => nil).update_all("container_id = group_id, container_type = 'Group'")
    Field.where.not(:poll_id => nil).update_all("container_id = poll_id, container_type = 'Poll'")
    Field.where.not(:initiative_id => nil).update_all("container_id = initiative_id, container_type = 'Initiative'")
    
    # folders for enterprises, groups
    Folder.where.not(:enterprise_id => nil).update_all("container_id = enterprise_id, container_type = 'Enterprise'")
    Folder.where.not(:group_id => nil).update_all("container_id = group_id, container_type = 'Group'")
    
    # folder_shares for enterprises, groups
    FolderShare.where.not(:enterprise_id => nil).update_all("container_id = enterprise_id, container_type = 'Enterprise'")
    FolderShare.where.not(:group_id => nil).update_all("container_id = group_id, container_type = 'Group'")
    
    # graphs for polls and metric_dashboards
    Graph.where.not(:metrics_dashboard_id => nil).update_all("collection_id = metrics_dashboard_id, collection_type = 'MetricsDashboard'")
    Graph.where.not(:poll_id => nil).update_all("collection_id = poll_id, collection_type = 'Poll'")
    
    # user_reward_actions
    UserRewardAction.where.not(:initiative_id => nil).update_all("entity_id = initiative_id, entity_type = 'Initiative'")
    UserRewardAction.where.not(:initiative_comment_id => nil).update_all("entity_id = initiative_comment_id, entity_type = 'InitiativeComment'")
    UserRewardAction.where.not(:group_message_id => nil).update_all("entity_id = group_message_id, entity_type = 'GroupMessage'")
    UserRewardAction.where.not(:group_message_comment_id => nil).update_all("entity_id = group_message_comment_id, entity_type = 'GroupMessageComment'")
    UserRewardAction.where.not(:news_link_id => nil).update_all("entity_id = news_link_id, entity_type = 'NewsLink'")
    UserRewardAction.where.not(:news_link_comment_id => nil).update_all("entity_id = news_link_comment_id, entity_type = 'NewsLinkComment'")
    UserRewardAction.where.not(:social_link_id => nil).update_all("entity_id = social_link_id, entity_type = 'SocialLink'")
    UserRewardAction.where.not(:answer_comment_id => nil).update_all("entity_id = answer_comment_id, entity_type = 'AnswerComment'")
    UserRewardAction.where.not(:answer_upvote_id => nil).update_all("entity_id = answer_upvote_id, entity_type = 'AnswerUpvote'")
    UserRewardAction.where.not(:answer_id => nil).update_all("entity_id = answer_id, entity_type = 'Answer'")
    UserRewardAction.where.not(:poll_response_id => nil).update_all("entity_id = poll_response_id, entity_type = 'PollResponse'")
    
    # resources
    Resource.where.not(:enterprise_id => nil).update_all("container_id = enterprise_id, container_type = 'Enterprise'")
    Resource.where.not(:folder_id => nil).update_all("container_id = folder_id, container_type = 'Folder'")
    Resource.where.not(:group_id => nil).update_all("container_id = group_id, container_type = 'Group'")
    Resource.where.not(:initiative_id => nil).update_all("container_id = initiative_id, container_type = 'Initiative'")
    
    # news_feed_links
    NewsFeedLink.where.not(:news_link_id => nil).update_all("link_id = news_link_id, link_type = 'NewsLink'")
    NewsFeedLink.where.not(:group_message_id => nil).update_all("link_id = group_message_id, link_type = 'GroupMessage'")
    NewsFeedLink.where.not(:social_link_id => nil).update_all("link_id = social_link_id, link_type = 'SocialLink'")
    
    remove_reference :tags,     :resource
    
    remove_reference :budgets,  :event
    remove_reference :budgets,  :group
    
    remove_reference :checklists,  :budget
    remove_reference :checklists,  :initiative
    
    remove_reference :checklist_items,  :initiative
    remove_reference :checklist_items,  :checklist
    
    remove_reference :fields,  :enterprise
    remove_reference :fields,  :event
    remove_reference :fields,  :group
    remove_reference :fields,  :poll
    remove_reference :fields,  :initiative
    
    remove_reference :folders,  :enterprise
    remove_reference :folders,  :group
    
    remove_reference :folder_shares,  :enterprise
    remove_reference :folder_shares,  :group
    
    remove_reference :graphs,  :metrics_dashboard
    remove_reference :graphs,  :poll
    
    remove_reference :user_reward_actions, :initiative
    remove_reference :user_reward_actions, :initiative_comment
    remove_reference :user_reward_actions, :group_message
    remove_reference :user_reward_actions, :group_message_comment
    remove_reference :user_reward_actions, :news_link
    remove_reference :user_reward_actions, :news_link_comment
    remove_reference :user_reward_actions, :social_link
    remove_reference :user_reward_actions, :answer_comment
    remove_reference :user_reward_actions, :answer_upvote
    remove_reference :user_reward_actions, :answer
    remove_reference :user_reward_actions, :poll_response
    
    remove_reference :resources, :enterprise
    remove_reference :resources, :folder
    remove_reference :resources, :group
    remove_reference :resources, :initiative
    
    remove_reference :news_feed_links,  :news_link
    remove_reference :news_feed_links,  :group_message
    remove_reference :news_feed_links,  :social_link
  end
end