after 'development:groups' do
  spinner = TTY::Spinner.new(":spinner Populating groups and enterprise with sponsors...", format: :spin_2)
  spinner.run do |spinner|

    sponsors = {:sponsor1 => ['Bill Gates', 'Founder of Microsoft', 'spec/fixtures/files/sponsor_image1.jpg'],
                :sponsor2 => ['Mark Zuckerberg', 'Founder & CEO of Facebook', 'spec/fixtures/files/sponsor_image.jpg'],
                :sponsor3 => ['Elon Musk', 'Founder & CEO of Space X', 'spec/fixtures/files/sponsor_image2.jpg']
    }

    # Group sponsor
    Enterprise.all.each do |enterprise|
      enterprise.groups.each do |group|
        s = sponsors.keys.sample
        Sponsor.create(sponsor_name: sponsors[s][0],
                       sponsor_title: sponsors[s][1],
                       sponsor_message: 'I welcome everyone to this initiative.',
                       sponsorable_type: 'Group',
                       sponsorable_id: group.id)
      end
    end


    # Enterprise sponsor TODO

    Enterprise.all.each do |enterprise|
      Sponsor.create(sponsor_name: sponsors[s][0],
                     sponsor_title: sponsors[s][1],
                     sponsor_message: 'I welcome everyone to this initiative.',
                     sponsorable_type: 'Enterprise',
                     sponsorable_id: enterprise.id)
    end

    spinner.success("[DONE]")
  end
end
