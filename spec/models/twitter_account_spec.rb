require 'rails_helper'

RSpec.describe TwitterAccount, type: :model do
  # let(:twitter_account) { create(:twitter_account) }
  describe 'validations' do
    # let(:twitter_account) { create(:twitter_account) }
    # it { expect(twitter_account).to validate_presence_of(:name) }
    # it { expect(twitter_account).to validate_uniqueness_of(:name).scoped_to(:group_id).case_insensitive }
    # it { expect(twitter_account).to validate_presence_of(:account) }
    # it { expect(twitter_account).to validate_uniqueness_of(:account).scoped_to(:group_id).case_insensitive }
    # it 'should validate that :account is a valid Twitter Account' do
    #   account = described_class.new(name: 'Alex Oxorn', account: 'QWERTYUnaljkKdsnfvjkahnkjKLJABHLKJ', group_id: 1)
    #   expect(account).to_not be_valid
    #   account.account = 'AOxorn'
    #   expect(account).to be_valid
    # end

    # describe 'name' do
    #   it { should validate_presence_of(:name) }
    #   # it 'must be present' do
    #   #   account = described_class.new(account: 'AOxorn')
    #   #   expect(account).to_not be_valid
    #   #   account.name = 'Alex Oxorn'
    #   #   expect(account).to be_valid
    #   # end
    #
    #   it { should validate_uniqueness_of(:name).scoped_to(:group_id).case_insensitive }
    #   # it 'must be unique within same group' do
    #   #
    #   #   account1 = described_class.new(account: 'AOxorn', name: 'Alex', group_id: 1)
    #   #   account2 = described_class.new(account: 'ADiverst', name: 'Alex', group_id: 1)
    #   #
    #   #   expect(account1).to be_valid
    #   #   expect(account2).to_not be_valid
    #   #
    #   #   account2.name = 'Diverst'
    #   #   expect(account2).to be_valid
    #   # end
    # end
    #
    # describe 'account' do
    #   it { should validate_presence_of(:account) }
    #   # it 'must be present' do
    #   #   account = described_class.new(name: 'Alex Oxorn')
    #   #   expect(account).to_not be_valid
    #   #   account.account = 'AOxorn'
    #   #   expect(account).to be_valid
    #   # end
    #
    #   it { should validate_uniqueness_of(:account).scoped_to(:group_id).case_insensitive }
    #
    #   it 'should validate that :account is a valid Twitter Account' do
    #     account = described_class.new(name: 'Alex Oxorn', account: 'QWERTYUnaljkKdsnfvjkahnkjKLJABHLKJ')
    #     expect(account).to_not be_valid
    #     account.account = 'AOxorn'
    #     expect(account).to be_valid
    #   end
    # end
  end
end
