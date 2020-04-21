require 'rails_helper'

DUMMY_ROUTES = {
    no_args: '/a/b/c/d',
    two_args: '/a/:b/c/:d',
    all_args: '/:a/:b/:c/:d',
    first_nest: {
        no_args: '/A/a/b/c/d',
        two_args: '/A/a/:b/c/:d',
        all_args: '/A/:a/:b/:c/:d',
        second_nest: {
            no_args: '/A/B/a/b/c/d',
            two_args: '/A/B/a/:b/c/:d',
            all_args: '/A/B/:a/:b/:c/:d',
        }
    }
}

DUMMY_DOMAIN = 'http://localhost:8082'

RSpec.describe ReactRoutes, type: :service do
  context 'with Routes' do
    before do
      allow(described_class).to receive(:routes_hash).and_return(DUMMY_ROUTES)
      allow(described_class).to receive(:domain).and_return(DUMMY_DOMAIN)
      allow(described_class).to receive(:routes).and_return(ReactRoutes.make_class ReactRoutes.routes_hash)
    end

    context 'with records' do
      let!(:enterprise) { create(:enterprise) }
      let!(:user) { create(:user) }

      it 'does nothing if not expecting args' do
        expect(described_class.no_args(enterprise, user)).to eq                           "#{DUMMY_DOMAIN}/a/b/c/d"
        expect(described_class.first_nest.no_args(enterprise, user)).to eq                "#{DUMMY_DOMAIN}/A/a/b/c/d"
        expect(described_class.first_nest.second_nest.no_args(enterprise, user)).to eq    "#{DUMMY_DOMAIN}/A/B/a/b/c/d"
      end

      it 'adds the argument where :params are' do
        expect(described_class.two_args(enterprise, user)).to eq                          "#{DUMMY_DOMAIN}/a/#{enterprise.id}/c/#{user.id}"
        expect(described_class.first_nest.two_args(enterprise, user)).to eq               "#{DUMMY_DOMAIN}/A/a/#{enterprise.id}/c/#{user.id}"
        expect(described_class.first_nest.second_nest.two_args(enterprise, user)).to eq   "#{DUMMY_DOMAIN}/A/B/a/#{enterprise.id}/c/#{user.id}"
      end

      it 'only adds as many argument which are given' do
        expect(described_class.all_args(enterprise, user)).to eq                          "#{DUMMY_DOMAIN}/#{enterprise.id}/#{user.id}/:c/:d"
        expect(described_class.first_nest.all_args(enterprise, user)).to eq               "#{DUMMY_DOMAIN}/A/#{enterprise.id}/#{user.id}/:c/:d"
        expect(described_class.first_nest.second_nest.all_args(enterprise, user)).to eq   "#{DUMMY_DOMAIN}/A/B/#{enterprise.id}/#{user.id}/:c/:d"
      end
    end

    context 'with integers' do
      it 'does nothing if not expecting args' do
        expect(described_class.no_args(1, 2)).to eq                             "#{DUMMY_DOMAIN}/a/b/c/d"
        expect(described_class.first_nest.no_args(1, 2)).to eq                  "#{DUMMY_DOMAIN}/A/a/b/c/d"
        expect(described_class.first_nest.second_nest.no_args(1, 2)).to eq      "#{DUMMY_DOMAIN}/A/B/a/b/c/d"
      end

      it 'adds the argument where :params are' do
        expect(described_class.two_args(1, 2)).to eq                            "#{DUMMY_DOMAIN}/a/1/c/2"
        expect(described_class.first_nest.two_args(1, 2)).to eq                 "#{DUMMY_DOMAIN}/A/a/1/c/2"
        expect(described_class.first_nest.second_nest.two_args(1, 2)).to eq     "#{DUMMY_DOMAIN}/A/B/a/1/c/2"
      end

      it 'only adds as many argument which are given' do
        expect(described_class.all_args(1, 2)).to eq                            "#{DUMMY_DOMAIN}/1/2/:c/:d"
        expect(described_class.first_nest.all_args(1, 2)).to eq                 "#{DUMMY_DOMAIN}/A/1/2/:c/:d"
        expect(described_class.first_nest.second_nest.all_args(1, 2)).to eq     "#{DUMMY_DOMAIN}/A/B/1/2/:c/:d"
      end
    end

    context 'with strings' do
      it 'does nothing if not expecting args' do
        expect(described_class.no_args('1', '2')).to eq                         "#{DUMMY_DOMAIN}/a/b/c/d"
        expect(described_class.first_nest.no_args('1', '2')).to eq              "#{DUMMY_DOMAIN}/A/a/b/c/d"
        expect(described_class.first_nest.second_nest.no_args('1', '2')).to eq  "#{DUMMY_DOMAIN}/A/B/a/b/c/d"
      end

      it 'adds the argument where :params are' do
        expect(described_class.two_args('1', '2')).to eq                        "#{DUMMY_DOMAIN}/a/1/c/2"
        expect(described_class.first_nest.two_args('1', '2')).to eq             "#{DUMMY_DOMAIN}/A/a/1/c/2"
        expect(described_class.first_nest.second_nest.two_args('1', '2')).to eq "#{DUMMY_DOMAIN}/A/B/a/1/c/2"
      end

      it 'only adds as many argument which are given' do
        expect(described_class.all_args('1', '2')).to eq                        "#{DUMMY_DOMAIN}/1/2/:c/:d"
        expect(described_class.first_nest.all_args('1', '2')).to eq             "#{DUMMY_DOMAIN}/A/1/2/:c/:d"
        expect(described_class.first_nest.second_nest.all_args('1', '2')).to eq "#{DUMMY_DOMAIN}/A/B/1/2/:c/:d"
      end
    end

    context 'with first_invalid' do
      it 'does nothing if not expecting args' do
        expect(described_class.no_args(1.0, 2)).to eq                           "#{DUMMY_DOMAIN}/a/b/c/d"
        expect(described_class.first_nest.no_args(1.0, 2)).to eq                "#{DUMMY_DOMAIN}/A/a/b/c/d"
        expect(described_class.first_nest.second_nest.no_args(1.0, 2)).to eq    "#{DUMMY_DOMAIN}/A/B/a/b/c/d"
      end

      it 'adds the second argument where :params are' do
        expect(described_class.two_args(1.0, 2)).to eq                          "#{DUMMY_DOMAIN}/a/:b/c/2"
        expect(described_class.first_nest.two_args(1.0, 2)).to eq               "#{DUMMY_DOMAIN}/A/a/:b/c/2"
        expect(described_class.first_nest.second_nest.two_args(1.0, 2)).to eq   "#{DUMMY_DOMAIN}/A/B/a/:b/c/2"
      end

      it 'only adds as many valid argument which are given' do
        expect(described_class.all_args(1.0, 2)).to eq                          "#{DUMMY_DOMAIN}/:a/2/:c/:d"
        expect(described_class.first_nest.all_args(1.0, 2)).to eq               "#{DUMMY_DOMAIN}/A/:a/2/:c/:d"
        expect(described_class.first_nest.second_nest.all_args(1.0, 2)).to eq   "#{DUMMY_DOMAIN}/A/B/:a/2/:c/:d"
      end
    end
  end
end
