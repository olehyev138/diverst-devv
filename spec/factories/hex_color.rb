FactoryBot.define do
  sequence :hex_color do
    '#' + '%06x' % (rand * 0xffffff)
  end
end
