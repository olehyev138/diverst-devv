class SetPositionToId < ActiveRecord::Migration[5.2]
  def self.up
    Field.update_all("position=id")
    Group.update_all("position=id")
  end

  def self.down
  end
end
