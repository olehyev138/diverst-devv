class View < BaseClass
  belongs_to :news_feed_link
  belongs_to :group
  belongs_to :user
  belongs_to :enterprise
  belongs_to :resource
  belongs_to :folder

  settings do
    mappings dynamic: false do
      indexes :enterprise_id, type: :integer
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
      indexes :news_feed_link do
        indexes :news_link do
          indexes :title, type: :keyword
        end
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      options.merge(
        only: [:enterprise_id, :title],
        include: { group: {
          only: [:name, :parent_id],
          include: { parent: { only: [:name] } }
        }, folder: {
          only: [:name],
        }, resource: {
          only: [:title],
        }, news_feed_link: {
          include: { news_link: { only: [:title] }}
        }}
      ))
  end
end
