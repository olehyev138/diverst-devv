require 'rails_helper'

RSpec.describe SocialMedia::Importer do
  describe 'self.url_to_embed' do
    subject { SocialMedia::Importer.url_to_embed(url) }

    context 'with correct url' do
      shared_examples 'does fetch oembed' do |url|
        it 'returns resourse html' do
          expect(subject).to_not be_empty

          # TODO check that this is valid html
        end
      end

      context 'with instagram' do
        let(:url) { 'https://www.instagram.com/p/tsxp1hhQTG/' }

        it_behaves_like 'does fetch oembed'
      end

      context 'with facebook' do
        let(:url) { 'https://www.facebook.com/20531316728/posts/10154009990506729/' }

        it_behaves_like 'does fetch oembed'
      end

      context 'with twitter' do
        let(:url) { 'https://twitter.com/Interior/status/870349439747198977' }

        it_behaves_like 'does fetch oembed'
      end

      context 'with youtube' do
        let(:url) { 'https://www.youtube.com/watch?v=Y2VF8tmLFHw' }

        it_behaves_like 'does fetch oembed'
      end

      context 'with linkedin' do
        let(:url) { 'https://www.linkedin.com/company/microsoft/' }

        it_behaves_like 'does fetch oembed'
      end
    end

    context 'with incorrect url' do
      shared_examples 'does not fetch oembed' do |url|
        it 'returns nil' do
          expect(subject).to eq nil
        end
      end

      context 'with corrupted url' do
        let(:url) { 'https://twitter.com/iamthewrongurl' }

        it_behaves_like 'does not fetch oembed'
      end

      context 'with not existent url' do
        let(:url) { 'https://sefsedf3sfddscx.rr/bbsedc' }

        it_behaves_like 'does not fetch oembed'
      end

      context 'with url from service we do not support', skip: 'we actually allow all those services' do
        let(:url) { 'http://coub.com/view/v9z7c' }

        it_behaves_like 'does not fetch oembed'
      end
    end
  end

  describe 'self.valid_url?' do
    subject { SocialMedia::Importer.valid_url?(url) }

    context 'with valid url' do
      shared_examples 'valid url' do |url|
        it 'returns true' do
          expect(subject).to eq true
        end
      end

      context 'with instagram' do
        let(:url) { 'https://www.instagram.com/p/tsxp1hhQTG/' }

        it_behaves_like 'valid url'
      end

      context 'with facebook' do
        let(:url) { 'https://www.facebook.com/20531316728/posts/10154009990506729/' }

        it_behaves_like 'valid url'
      end

      context 'with twitter' do
        let(:url) { 'https://twitter.com/Interior/status/870349439747198977' }

        it_behaves_like 'valid url'
      end

      context 'with youtube' do
        let(:url) { 'https://www.youtube.com/watch?v=Y2VF8tmLFHw' }

        it_behaves_like 'valid url'
      end

      context 'with linkedin' do
        let(:url) { 'https://www.linkedin.com/company/microsoft/' }

        it_behaves_like 'valid url'
      end
    end

    context 'with invalid url' do
      shared_examples 'invalid url' do |url|
        it 'returns fals' do
          expect(subject).to eq false
        end
      end

      context 'with corrupted url' do
        let(:url) { 'https://twitter.com/iamthewrongurl' }

        it_behaves_like 'invalid url'
      end

      context 'with not existent url' do
        let(:url) { 'https://sefsedf3sfddscx.rr/bbsedc' }

        it_behaves_like 'invalid url'
      end

      context 'with url from service we do not support', skip: 'we actually support coub' do
        let(:url) { 'http://coub.com/view/v9z7c' }

        it_behaves_like 'invalid url'
      end
    end
  end
end
