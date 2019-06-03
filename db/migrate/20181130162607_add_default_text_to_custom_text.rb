class AddDefaultTextToCustomText < ActiveRecord::Migration
  def change
    change_column :custom_texts, :erg, :string, default: 'Group'
    change_column :custom_texts, :program, :string, default: 'Goal'
    change_column :custom_texts, :structure, :string, default: 'Structure'
    change_column :custom_texts, :outcome, :string, default: 'Focus Areas'
    change_column :custom_texts, :badge, :string, default: 'Badge'
    change_column :custom_texts, :segment, :string, default: 'Segment'
    change_column :custom_texts, :dci_full_title, :string, default: 'Engagement'
    change_column :custom_texts, :dci_abbreviation, :string, default: 'Engagement'
    change_column :custom_texts, :member_preference, :string, default: 'Member Survey'
    change_column :custom_texts, :parent, :string, default: 'Parent'
    change_column :custom_texts, :sub_erg, :string, default: 'Sub-Group'
    change_column :custom_texts, :privacy_statement, :string, default: 'Privacy Statement'
  end
end
