class FolderShare < ActiveRecord::Base
    
  # associations
  belongs_to  :container, polymorphic: true
  belongs_to  :folder
  
  # validations
  validates :container, presence: true
  validates :folder,    presence: true
  
end
