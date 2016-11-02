class Budget < ActiveRecord::Base
  belongs_to :subject, polymorphic: true

  def status_title
    return 'Pending' if is_approved.nil?

    if is_approved
      'Approved'
    else
      'Rejected'
    end
  end
end
