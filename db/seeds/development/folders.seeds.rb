after 'development:groups' do 
	Enterprise.all.each do |enterprise|
		FactoryGirl.create_list :folder, 5, enterprise_id: enterprise.id, group_id: nil

		enterprise.groups.each do |group|
			FactoryGirl.create_list :folder, 5, group_id: group.id, enterprise_id: nil
		end

		#create nested folders
		FactoryGirl.create :folder, 
		enterprise_id: enterprise.id, 
		parent_id: enterprise.folders.first.id, 
		group_id: nil

		FactoryGirl.create :folder, 
		enterprise_id: nil, 
		group_id: enterprise.groups.first.id, 
		parent_id: enterprise.groups.first.folders.first.id 
	end
end