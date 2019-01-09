after 'development:enterprise' do
  spinner = TTY::Spinner.new("[:spinner] Populate enterprise with prize...", format: :classic)
  spinner.run('[DONE]') do |spinner|
    Rewards::Actions::Boilerplate.generate

    enterprise = Enterprise.find_by_name 'Diverst Inc'
    point_system = [[100, 'Gold Achievement', 'spec/fixtures/files/trophy_image.jpg'], [50, 'Silver Achievement', 'spec/fixtures/files/silver.jpg']]
	point_system.each do |p|
		Badge.create(enterprise_id: enterprise.id, 
					points: p[0],
					image: File.open(p[2]), 
					label: p[1])
	end
  end
end
