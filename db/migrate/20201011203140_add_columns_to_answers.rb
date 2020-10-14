class AddColumnsToAnswers < ActiveRecord::Migration[5.2]
  def change
    #
    ## Legacy migration
    #
    unless column_exists? :answers, :benefits
      add_column :answers, :benefits, :text
    end

    unless column_exists? :answers, :duration
      add_column :answers, :duration, :integer, default: 0
    end

    unless column_exists? :answers, :unit_of_duration
      add_column :answers, :unit_of_duration, :string, default: ''
    end
  end
end
