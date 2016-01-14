class CreateEmails < ActiveRecord::Migration
  def change
    create_table :emails do |t|
      t.string :name
      t.string :slug
      t.boolean :use_custom_templates
      t.text :custom_html_template
      t.text :custom_txt_template

      t.belongs_to :enterprise

      t.timestamps null: false
    end
  end
end
