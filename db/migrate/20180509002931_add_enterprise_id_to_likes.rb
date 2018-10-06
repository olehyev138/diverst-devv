class AddEnterpriseIdToLikes < ActiveRecord::Migration
  def change
    add_reference :likes, :enterprise, index: true, foreign_key: true
  end
end
