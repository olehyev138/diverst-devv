class Budget < ActiveRecord::Base
  belongs_to :subject, polymorphic: true

  has_many :checklists, as: :subject

  has_many :checklist_items, as: :container
  accepts_nested_attributes_for :checklist_items, reject_if: :all_blank, allow_destroy: true

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
