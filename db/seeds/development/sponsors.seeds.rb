after 'development:groups' do
  # TODO
  # ActiveStorage

#  spinner = TTY::Spinner.new(":spinner Populating groups and enterprise with sponsors...", format: :spin_2)
#  spinner.run do |spinner|
#    enterprise = Enterprise.find_by_name 'Diverst Inc'
#
#    sponsors = {:sponsor1 => ['Bill Gates', 'Founder of Microsoft', 'spec/fixtures/files/sponsor_image1.jpg'],
#                :sponsor2 => ['Mark Zuckerberg', 'Founder & CEO of Facebook', 'spec/fixtures/files/sponsor_image.jpg'],
#                :sponsor3 => ['Elon Musk', 'Founder & CEO of Space X', 'spec/fixtures/files/sponsor_image2.jpg']
#    }
#
#    # Group sponsor
#    enterprise.groups.each do |group|
#      s = sponsors.keys.sample
#      Sponsor.create(sponsor_name: sponsors[s][0],
#                     sponsor_title: sponsors[s][1],
#                     sponsor_message: 'I welcome everyone to this initiative.',
#                     sponsorable: group,
#                     sponsor_media: File.open(sponsors[s][2]))
#    end
#
#    # Enterprise sponsor
#    s = sponsors.keys.sample
#    Sponsor.create(sponsor_name: sponsors[s][0],
#                   sponsor_title: sponsors[s][1],
#                   sponsor_message: 'I welcome everyone to this initiative.',
#                   sponsorable: enterprise,
#                   sponsor_media: File.open(sponsors[s][2]))
#
#    spinner.success("[DONE]")
#  end
end
