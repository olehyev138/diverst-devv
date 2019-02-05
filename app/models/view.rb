class View < BaseClass
  belongs_to :news_feed_link
  belongs_to :group
  belongs_to :user
  belongs_to :enterprise
  belongs_to :resource
  belongs_to :folder

  settings do
    mappings dynamic: false do
      indexes :group do
        indexes :name, type: :keyword
        indexes :parent_id, type: :integer
        indexes :parent do
          indexes :name, type: :keyword
        end
      end
      indexes :folder do
        indexes :name, type: :keyword
      end
      indexes :resource do
        indexes :title, type: :keyword
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      options.merge(
        only: [],
        include: { group: {
          only: [:name, :parent_id],
          include: { parent: { only: [:name] } }
        }, folder: {
          only: [:name],
        }, resource: {
          only: [:title],
        }}
      )
    )
  end
end
