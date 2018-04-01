class CreateMentorshipModule < ActiveRecord::Migration
  def change
    # type determines whether user is interesting in mentorship
    create_table :mentorships do |t|
      t.references  :user,        index: true, foreign_key: true, null: false
      t.boolean     :mentor,      default: false
      t.boolean     :mentee,      default: true
      t.text        :description
      t.timestamps
    end
    
    # connects mentors/mentees together - a mentee can have many mentors and
    # a mentor can have many mentees - a user can be both mentor and mentee
    
    create_table :mentorings do |t|
      t.references  :mentor
      t.references  :mentee
      t.timestamps
    end
    
    create_table :mentorship_availabilities do |t|
      t.references  :mentorship,  index: true, foreign_key: true, null: false
      t.datetime    :start,       null: false
      t.datetime    :end,         null: false
      t.timestamps
    end
    
    # individual, one_time, small_group, ongoing
    create_table :mentoring_types do |t|
      t.string  :name, null: false
      t.timestamps
    end
    
    create_table :mentorship_types do |t|
      t.references  :mentorship,      null: false
      t.references  :mentoring_type, null: false
      t.timestamps
    end
    
    # Accounting, Marketing, Leadership
    create_table :mentoring_interests do |t|
      t.string  :name, null: false
      t.timestamps
    end
    
    create_table :mentorship_interests do |t|
      t.references  :mentorship,          null: false
      t.references  :mentoring_interest,  null: false
      t.timestamps
    end
    
    create_table :mentoring_requests do |t|
      t.string      :type,    :null => false
      t.string      :status,  :null => false
      t.text        :notes
      t.timestamps
    end
    
    create_table :mentoring_request_interests do |t|
      t.references  :mentoring_request,   null: false
      t.references  :mentoring_interest,  null: false
      t.timestamps
    end
    
    create_table :mentorship_requests do |t|
      t.references  :mentorship,        null: false
      t.references  :mentoring_request, null: false
      t.timestamps
    end
    
    create_table :mentoring_sessions do |t|
      t.datetime    :start,   :null => false
      t.datetime    :end,     :null => false
      t.string      :format,  :null => false
      t.string      :link,    :null => true
      t.string      :status,  :null => false, :default => "scheduled"
      t.text        :notes,   :null => true
      t.timestamps
    end
    
    create_table :mentorship_sessions do |t|
      t.references  :mentorship,          null: false
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
      t.references  :mentorship,        null: false
      t.references  :mentoring_session, null: false
      t.boolean     :okrs_achieved,     default: false
      t.boolean     :valuable,          default: false
      t.text        :comments,          null: false
      t.timestamps
    end
  end
end
