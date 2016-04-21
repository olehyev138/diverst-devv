class AddExpensesToCampaigns < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.belongs_to :enterprise
      t.string :name
      t.integer :price
      t.string :category
    end

    create_table :answer_expenses do |t|
      t.belongs_to :answer
      t.belongs_to :expense
      t.integer :quantity
    end
  end
end
