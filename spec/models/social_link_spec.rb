require 'rails_helper'

RSpec.describe SocialLink, type: :model do
  describe 'validation' do
    let(:social_link) { build :social_link }

    it 'has valid factory' do
      expect(social_link).to be_valid
    end

    it{ expect(social_link).to validate_presence_of(:author) }

    describe 'url population' do
      let(:social_link) { build :social_link, :without_embed_code}

      context 'with correct url' do
        before { social_link.save }

        it 'creates new instance' do
          expect(social_link).to be_persisted
          expect(social_link).to be_valid
        end

        it 'populates embed code' do
          expect(social_link.embed_code).to_not be_empty
        end
      end

      context 'with incorrect url' do
        before do
          social_link.url = 'https://blahblah.rb/deffdsieh'
          social_link.save
        end

        it 'does not populate embed code' do
          expect(social_link.embed_code).to be_nil
        end

        it 'adds error message' do
          expect(social_link).to_not be_valid
          expect(social_link.errors[:url]).to include('is not a valid url for supported services')
        end
      end
    end
  end
end
