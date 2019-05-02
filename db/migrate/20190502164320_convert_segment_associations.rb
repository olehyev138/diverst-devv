class ConvertSegmentAssociations < ActiveRecord::Migration
  def up
    # Add parent_id column
    add_reference :segments, :parent, index: true

    Segment.reset_column_information

    # Restructure sub segments
    # Query the db raw as the Segmentation model will not exist
    say 'Moving & rewriting references'
    sql = 'SELECT * FROM segmentations'
    results = ActiveRecord::Base.connection.execute(sql).to_a

    results.each do |record|
      parent_id = record[1]
      child_id = record[2]
      child_segment = Segment.find(child_id)

      child_segment.update_column(:parent_id, parent_id)
    end
  end

  def down
    say 'Creating segmentations'
    Segment.where('parent_id IS NOT NULL').each do |record|
      sql = "INSERT INTO segmentations (parent_id, child_id, created_at, updated_at)
               VALUES (#{record.parent_id}, #{record.id}, '#{Time.now.to_s(:db)}', '#{Time.now.to_s(:db)}')"

      ActiveRecord::Base.connection.execute(sql)
    end

    remove_column :segments, :parent_id
  end
end