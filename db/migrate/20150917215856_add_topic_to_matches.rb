class AddTopicToMatches < ActiveRecord::Migration
  def change
    change_table :matches do |t|
      t.belongs_to :topic
    end
  end
end
