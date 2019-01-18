class UsersSegment < BaseClass
  belongs_to :user
  belongs_to :segment

  # validations
  validates_uniqueness_of :user, scope: [:segment], :message => "is already a member of this segment"

  settings do
    mappings dynamic: false do
      indexes :segment  do
        indexes :name, type: :keyword
        indexes :parent do
          indexes :name, type: :keyword
        end
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      options.merge(
        include: { segment: {
          only: [:name],
          include: { parent: { only: [:name] } }
        }}
      )
    )
  end

end
