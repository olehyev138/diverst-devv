after 'production:enterprise' do
  spinner = TTY::Spinner.new(":spinner Creating tech admin user...", format: :spin_2)
  spinner.run do |spinner|
    Enterprise.all.each do |enterprise|
      # Create default enterprise user roles
      enterprise.user_roles.create!(
          [
              {:role_name => "Admin", :role_type => "user", :priority => 0},
              {:role_name => "Diversity Manager", :role_type => "user", :priority => 1},
              {:role_name => "National Manager", :role_type => "user", :priority => 2},
              {:role_name => "Group Leader", :role_type => "group", :priority => 3},
              {:role_name => "Group Treasurer", :role_type => "group", :priority => 4},
              {:role_name => "Group Content Creator", :role_type => "group", :priority => 5},
              {:role_name => "User", :role_type => "user", :priority => 6, :default => true}
          ]
      )
      # Create admin user
      admin_user = FactoryBot.create(:user,
                                     first_name: "Tech",
                                     last_name: "Admin",
                                     email: "tech@diverst.com",
                                     enterprise: enterprise,
                                     password: 'Password!123',
                                     password_confirmation: 'Password!123',
                                     user_role_id: enterprise.user_roles.find_by_role_name("Admin").id,
                                     created_at: Time.now,
                                     invitation_accepted_at: Time.now
      )
    end
  end
  spinner.success("[DONE]")
end
