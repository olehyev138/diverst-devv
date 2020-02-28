class View < ApplicationRecord
  include PublicActivity::Common

  belongs_to :news_feed_link, counter_cache: true
  belongs_to :group, counter_cache: true
  belongs_to :user
  belongs_to :enterprise
  belongs_to :resource, counter_cache: true
  belongs_to :folder, counter_cache: true

  settings do
    mappings dynamic: false do
      indexes :enterprise_id, type: :integer
      indexes :created_at, type: :date
      indexes :group_id, type: :integer
      indexes :group do
        indexes :name, type: :keyword
        indexes :parent_id, type: :integer
        indexes :parent do
          indexes :name, type: :keyword
        end
      end
      indexes :folder do
        indexes :id, type: :integer
        indexes :name, type: :keyword
        indexes :group do
          indexes :id, type: :integer
          indexes :name, type: :keyword
        end
      end
      indexes :resource do
        indexes :id, type: :integer
        indexes :title, type: :keyword
        indexes :group do
          indexes :id, type: :integer
          indexes :name, type: :keyword
        end
      end
      indexes :news_feed_link do
        indexes :news_link do
          indexes :id, type: :integer
          indexes :title, type: :keyword
        end
        indexes :group do
          indexes :id, type: :integer
          indexes :name, type: :keyword
        end
      end
    end
  end

  def as_indexed_json(options = {})
    self.as_json(
      options.merge(
        only: [:enterprise_id, :group_id, :title, :created_at],
        include: {
          group: {
            only: [:name, :parent_id],
            include: { parent: { only: [:name] } }
          },
          folder: {
            only: [:id, :name],
            include: { group: { only: [:id, :name] } }
          },
          resource: {
            only: [:id, :title],
            include: { group: { only: [:id, :name] } }
          },
          news_feed_link: {
            only: [],
            include: {
              news_link: { only: [:id, :title] },
              group: { only: [:id, :name] }
            }
          },
        }
      )
    ).merge({ 'created_at' => self.created_at.beginning_of_hour })
  end
end
