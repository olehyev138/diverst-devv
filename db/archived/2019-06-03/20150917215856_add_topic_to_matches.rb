class AddTopicToMatches < ActiveRecord::Migration[5.1]
  def change
    change_table :matches do |t|
      t.belongs_to :topic
    end
  end
end
