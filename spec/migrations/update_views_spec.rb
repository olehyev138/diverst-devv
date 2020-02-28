require 'rails_helper'

migration_file_name = Dir[Rails.root.join('db/migrate/20190128204226_update_views.rb')].first
require migration_file_name

RSpec.describe UpdateViews, type: :migration do
  let(:migration) { UpdateViews.new }

  describe '#up' do
    it 'removes the view_count column' do
      View.reset_column_information

      if !View.columns_hash.include?('view_count')
        migration.migrate(:down)
        View.reset_column_information
      end

      create(:view, view_count: 10)
      expect(View.all.count).to eq(1)

      migration.migrate(:up)
      View.reset_column_information

      expect(View.columns_hash).not_to include('view_count')
      expect(View.all.count).to eq(10)
    end
  end

  describe '#down' do
    it 'keeps the view_count column' do
      View.reset_column_information

      if View.columns_hash.include?('view_count')
        migration.migrate(:up)
        View.reset_column_information
      end

      View.reset_column_information
      migration.migrate(:down)

      View.reset_column_information
      expect(View.columns_hash).to include('view_count')
    end
  end
end
