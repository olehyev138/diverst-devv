class MovePasswordHashes < ActiveRecord::Migration[5.2]
  def change
    User.all.each do |user|
      if column_exists?(:users, :password_digest) && column_exists?(:users, :encrypted_password) && user.password_digest == nil && user.encrypted_password != nil
        say "Moving password hash for user #{user.id}"
        user.password_digest = user.encrypted_password
        user.save!(validate: false)
      end
    end
  end
end
