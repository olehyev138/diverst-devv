class AddIndicesToWhereNeeded < ActiveRecord::Migration[5.2]
  def change
    add_index :answer_comments, [:author_id]
    add_index :answer_comments, [:answer_id]

    add_index :answers, [:question_id]
    add_index :answers, [:author_id]

    add_index :campaign_invitations, [:campaign_id]
    add_index :campaign_invitations, [:user_id]

    add_index :campaigns_groups, [:campaign_id]
    add_index :campaigns_groups, [:group_id]

    add_index :campaigns_managers, [:campaign_id]
    add_index :campaigns_managers, [:user_id]

    add_index :campaigns_segments, [:campaign_id]
    add_index :campaigns_segments, [:segment_id]

    add_index :checklist_items, [:initiative_id]
    add_index :checklist_items, [:checklist_id]

    add_index :checklists, [:initiative_id]

    add_index :emails, [:enterprise_id]
    add_index :enterprise_email_variables, [:enterprise_id]
    add_index :expense_categories, [:enterprise_id]
    add_index :expenses, [:enterprise_id]

    add_index :folder_shares, [:group_id]
    add_index :folder_shares, [:enterprise_id]

    add_index :folders, [:group_id]
    add_index :folders, [:enterprise_id]

    add_index :group_message_comments, [:author_id]
    add_index :group_message_comments, [:message_id]

    add_index :group_messages, [:group_id]
    add_index :group_messages, [:owner_id]

    add_index :group_messages_segments, [:group_message_id]
    add_index :group_messages_segments, [:segment_id]

    add_index :groups_polls, [:group_id]
    add_index :groups_polls, [:poll_id]

    add_index :initiative_expenses, [:initiative_id]

    add_index :initiative_groups, [:initiative_id]
    add_index :initiative_groups, [:group_id]

    add_index :initiative_users, [:initiative_id]
    add_index :initiative_users, [:user_id]

    add_index :initiatives, [:pillar_id]

    add_index :invitation_segments_groups, [:segment_id]
    add_index :invitation_segments_groups, [:group_id]

    add_index :mentoring_interests, [:enterprise_id]

    add_index :mentoring_request_interests, [:mentoring_request_id]
    add_index :mentoring_request_interests, [:mentoring_interest_id]

    add_index :mentoring_requests, [:sender_id]
    add_index :mentoring_requests, [:receiver_id]
    add_index :mentoring_requests, [:enterprise_id]

    add_index :mentoring_session_topics, [:mentoring_interest_id]
    add_index :mentoring_session_topics, [:mentoring_session_id]

    add_index :mentoring_sessions, [:creator_id]

    add_index :mentoring_types, [:enterprise_id]

    add_index :mentorings, [:mentor_id]
    add_index :mentorings, [:mentee_id]

    add_index :mentorship_interests, [:user_id]
    add_index :mentorship_interests, [:mentoring_interest_id]

    add_index :mentorship_ratings, [:user_id]

    add_index :mentorship_sessions, [:user_id]
    add_index :mentorship_sessions, [:mentoring_session_id]

    add_index :mentorship_types, [:user_id]
    add_index :mentorship_types, [:mentoring_type_id]

    add_index :mobile_fields, [:field_id]
    add_index :mobile_fields, [:enterprise_id]

    add_index :news_feed_link_segments, [:news_feed_link_id]
    add_index :news_feed_link_segments, [:segment_id]
    add_index :news_feed_link_segments, [:news_link_segment_id]
    add_index :news_feed_link_segments, [:group_messages_segment_id]
    add_index :news_feed_link_segments, [:social_link_segment_id]

    add_index :news_feeds, [:group_id]

    add_index :news_link_comments, [:author_id]
    add_index :news_link_comments, [:news_link_id]

    add_index :news_link_photos, [:news_link_id]

    add_index :news_link_segments, [:news_link_id]
    add_index :news_link_segments, [:segment_id]

    add_index :news_links, [:group_id]

    add_index :outcomes, [:group_id]

    add_index :pillars, [:outcome_id]

    add_index :policy_group_templates, [:user_role_id]
    add_index :policy_group_templates, [:enterprise_id]

    add_index :poll_responses, [:poll_id]

    add_index :polls, [:owner_id]
    add_index :polls, [:enterprise_id]

    add_index :polls_segments, [:segment_id]
    add_index :polls_segments, [:poll_id]

    add_index :questions, [:campaign_id]

    add_index :resources, [:owner_id]
    add_index :resources, [:group_id]
    add_index :resources, [:folder_id]
    add_index :resources, [:enterprise_id]
    add_index :resources, [:initiative_id]
    add_index :resources, [:mentoring_session_id]

    add_index :segment_field_rules, [:segment_id]
    add_index :segment_field_rules, [:field_id]

    add_index :shared_news_feed_links, [:news_feed_link_id]
    add_index :shared_news_feed_links, [:news_feed_id]

    add_index :social_link_segments, [:social_link_id]
    add_index :social_link_segments, [:segment_id]

    add_index :survey_managers, [:survey_id]
    add_index :survey_managers, [:user_id]

    add_index :tags, [:name]

    add_index :topic_feedbacks, [:topic_id]
    add_index :topic_feedbacks, [:user_id]

    add_index :topics, [:user_id]
    add_index :topics, [:enterprise_id]
    add_index :topics, [:category_id]

    add_index :user_groups, [:user_id]
    add_index :user_groups, [:group_id]

    add_index :users_segments, [:segment_id]
  end
end
