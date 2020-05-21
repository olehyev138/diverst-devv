class FolderShare < BaseClass
  # associations
  belongs_to  :group
  belongs_to  :enterprise
  belongs_to  :folder

  validates :folder, presence: true
end
