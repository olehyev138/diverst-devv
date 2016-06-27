class AddBooleanFieldsToBiases < ActiveRecord::Migration
  def change
    change_table :biases do |t|
      t.boolean :spoken_words,              default: false
      t.boolean :marginalized_in_meetings,  default: false
      t.boolean :called_name ,              default: false
      t.boolean :contributions_ignored ,    default: false
      t.boolean :in_documents,              default: false
      t.boolean :unfairly_criticized ,      default: false
    end
  end
end