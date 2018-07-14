class Sponsor < ActiveRecord::Base
  belongs_to :sponsorable, polymorphic: true
end
