require 'rails_helper'

RSpec.describe ThemeSerializer, type: :serializer do
  it 'returns theme' do
    theme = create(:theme)
    serializer = ThemeSerializer.new(theme, scope: serializer_scopes(create(:user)))

    expect(serializer.serializable_hash[:primary_color]).to eq(theme.primary_color)
  end
end
