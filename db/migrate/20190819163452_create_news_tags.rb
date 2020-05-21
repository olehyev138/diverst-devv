class CreateNewsTags < ActiveRecord::Migration
  # def change
  #   create_table :news_tags do |t|
  #     t.string :name
  #
  #     t.timestamps null: false
  #   end
  # end

  def change
    create_table :news_tags, id: false do |t|
      t.string :name, primary_key: true

      t.timestamps null: false
    end
  end
end
