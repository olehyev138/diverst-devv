class CreateMentorshipModule < ActiveRecord::Migration
  def change
    # type determines whether mentor or mentee
    create_table :mentorships do |t|
      t.string      :type,        null: false       
      t.references  :user,        index: true, foreign_key: true, null: false
      t.text        :description
      t.timestamps
    end
    
    create_table :mentoring_availabilites do |t|
      t.references  :mentorship, index: true, foreign_key: true, null: false
      t.datetime    :date, null: false
      t.timestamps
    end
    
    # individual, one_time, small_group, ongoing
    create_table :mentoring_types do |t|
      t.string  :name, null: false
      t.timestamps
    end
    
    create_table :mentorship_types do |t|
      t.references  :mentorship,      null: false
      t.references  :mentorship_type, null: false
      t.timestamps
    end
    
    # Accounting, Marketing, Leadership
    create_table :mentoring_interests do |t|
      t.string  :name, null: false
      t.timestamps
    end
    
    create_table :mentorship_interests do |t|
      t.references  :mentorship,          null: false
      t.references  :mentorship_interest, null: false
      t.timestamps
    end
    
    create_table :mentoring_requests do |t|
      t.string      :type,    :null => false
      t.string      :status,  :null => false
      t.timestamps
    end
    
    create_table :mentoring_request_interests do |t|
      t.references  :mentoring_request,   null: false
      t.references  :mentorship_interest, null: false
      t.timestamps
    end
    
    create_table :mentorship_requests do |t|
      t.references  :mentorship,          null: false
      t.references  :mentorship_request,  null: false
      t.timestamps
    end
    
    create_table :mentoring_sessions do |t|
      t.datetime    :start,     :null => false
      t.datetime    :end,       :null => false
      t.string      :format,    :null => false
      t.string      :link,      :null => false
      t.string      :status,    :null => false
      t.text        :comments,  :null => false
      t.timestamps
    end
    
    create_table :mentorship_sessions do |t|
      t.references  :mentorship,          null: false
      t.references  :mentorship_session,  null: false
      t.boolean     :attending,           default: false
      t.timestamps
    end
    
    create_table :mentoring_session_materials do |t|
      t.references  :mentorship_session,  null: false
      t.string      :name,                null: false
      t.attachment  :file
      t.timestamps
    end

    create_table :mentoring_session_topics do |t|
      t.references  :mentoring_interest,   null: false
      t.references  :mentoring_session, null: false
      t.timestamps
    end
  
    create_table :mentorship_ratings do |t|
      t.integer     :rating,            null: false
      t.references  :mentorship,        null: false
      t.references  :mentoring_session, null: false
      t.boolean     :okrs_achieved,     default: false
      t.boolean     :valuable,          default: false
      t.text        :comments,          null: false
      t.timestamps
    end
  end
end
