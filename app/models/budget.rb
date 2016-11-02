class Budget < ActiveRecord::Base
  belongs_to :subject, polymorphic: true

  def status_title
    return 'Pending' if is_approved.nil?

    if is_approved
      if requested_amount == agreed_amount
        'Fully Approved'
      else
        'Partially Approved'
      end
    else
      'Rejected'
    end
  end
end
