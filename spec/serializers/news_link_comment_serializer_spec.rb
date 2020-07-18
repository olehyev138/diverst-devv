require 'rails_helper'

RSpec.describe NewsLinkCommentSerializer, type: :serializer do
  it 'returns news link comment' do
    news_link_comment = create(:news_link_comment)
    serializer = NewsLinkCommentSerializer.new(news_link_comment, scope: serializer_scopes(create(:user)), scope_name: :scope)

    expect(serializer.serializable_hash[:id]).to eq(news_link_comment.id)
    expect(serializer.serializable_hash[:author_id]).to eq(news_link_comment.author_id)
  end
end
