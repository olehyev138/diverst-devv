class CreateMentorshipModule < ActiveRecord::Migration
  def change
    # type determines whether user is interesting in mentorship and the type
    add_column :users, :mentee,                 :boolean, :default => false
    add_column :users, :mentor,                 :boolean, :default => false
    add_column :users, :mentorship_description, :text
    
    # connects mentors/mentees together - a mentee can have many mentors and
    # a mentor can have many mentees - a user can be both mentor and mentee
    
    create_table :mentorings do |t|
      t.references  :mentor, :references => :users
      t.references  :mentee, :references => :users
      t.timestamps
    end
    
    create_table :mentorship_availabilities do |t|
      t.references  :user,    index: true, foreign_key: true, null: false
      t.datetime    :start,   null: false
      t.datetime    :end,     null: false
      t.timestamps
    end
    
    # individual, one_time, small_group, ongoing
    create_table :mentoring_types do |t|
      t.references  :enterprise
      t.string      :name,      null: false
      t.timestamps
    end
    
    create_table :mentorship_types do |t|
      t.references  :user,            null: false
      t.references  :mentoring_type,  null: false
      t.timestamps
    end
    
    # Accounting, Marketing, Leadership
    create_table :mentoring_interests do |t|
      t.references  :enterprise
      t.string      :name, null: false
      t.timestamps
    end
    
    create_table :mentorship_interests do |t|
      t.references  :user,                null: false
      t.references  :mentoring_interest,  null: false
      t.timestamps
    end
    
    create_table :mentoring_requests do |t|
      t.references  :enterprise
      t.string      :status,    :null => false, :default => "pending"
      t.text        :notes
      t.references  :sender,    :null => false, :references => :users
      t.references  :receiver,  :null => false, :references => :users
      t.timestamps
    end
    
    create_table :mentoring_request_interests do |t|
      t.references  :mentoring_request,   null: false
      t.references  :mentoring_interest,  null: false
      t.timestamps
    end

    create_table :mentoring_sessions do |t|
      t.references  :enterprise
      t.references  :creator,     :null => false, :references => :users
      t.datetime    :start,       :null => false
      t.datetime    :end,         :null => false
      t.string      :format,      :null => false
      t.string      :link,        :null => true
      t.string      :status,      :null => false, :default => "scheduled"
      t.text        :notes,       :null => true
      t.timestamps
    end
    
    # ability to add preparation materials
    add_reference :resources, :mentoring_session
    
    create_table :mentorship_sessions do |t|
      t.references  :user,                null: false
      t.references  :mentoring_session,   null: false
      t.boolean     :attending,           default: true
      t.timestamps
    end

    create_table :mentoring_session_topics do |t|
      t.references  :mentoring_interest,   null: false
      t.references  :mentoring_session, null: false
      t.timestamps
    end
  
    create_table :mentorship_ratings do |t|
      t.integer     :rating,            null: false
      t.references  :user,              null: false
      t.references  :mentoring_session, null: false
      t.boolean     :okrs_achieved,     default: false
      t.boolean     :valuable,          default: false
      t.text        :comments,          null: false
      t.timestamps
    end
    
    add_column :enterprises, :mentorship_module_enabled, :boolean, :default => false
  end
end
