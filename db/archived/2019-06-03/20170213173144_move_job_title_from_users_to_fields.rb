class MoveJobTitleFromUsersToFields < ActiveRecord::Migration[5.1]
  def up
    User.find_in_batches(batch_size: 200) do |users|
      users.each do |user|
        job_title = user.job_title
        field = TextField.find_or_create_by(container_id: user.enterprise_id, title: "Job title",
          type: "TextField", container_type: "Enterprise")
        user[field] = field.process_field_value job_title
        user.save!
      end
    end
    remove_column :users, :job_title
  end

  def down
    add_column :users, :job_title, :string
    field = TextField.find_by(title: "Job title")
    User.find_in_batches(batch_size: 200) do |users|
      users.each do |user|
        info = user.info
        user.update(job_title: info.fetch(field.id))
      end
    end
  end
end
