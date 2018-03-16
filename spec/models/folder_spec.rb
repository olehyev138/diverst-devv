require 'rails_helper'

RSpec.describe Folder, type: :model do

    describe "when validating" do
        let(:group) { create(:group) }
        let(:folder){ create(:folder, :name => "test", :container => group) }

        it { expect(folder).to have_many(:resources) }
        it { expect(folder).to have_many(:folder_shares) }
        it { expect(folder).to have_many(:groups).through(:folder_shares).source('container') }

        it{ expect(folder).to belong_to(:container) }

        it { expect(folder).to validate_presence_of(:name) }
        it { expect(folder).to validate_presence_of(:container) }
        #it { expect(folder).to validate_uniqueness_of(:name) } # <- revisit
    end

    describe 'test that' do
        let!(:new_folder) { build(:folder) }

        it 'set_password callback runs before object is saved' do
            expect(new_folder).to receive(:set_password)
            new_folder.save
        end
    end

    describe "#password" do
        it "doesnt create the password for the folder" do
            folder = create(:folder)
            expect(folder.password_digest).to be(nil)
        end

        it "doesnt save the password for the folder when password_protected is false" do
            folder = create(:folder, :password => "password", :password_confirmation => "password")
            expect(folder.password_digest).to be(nil)
        end

        it "saves the password for the folder when password_protected is true" do
            folder = create(:folder, :password_protected => true, :password => "password", :password_confirmation => "password")
            expect(folder.password_digest).to_not be(nil)
        end

        it "saves the password for the folder when password_protected is true and doesn't validate the password" do
            folder = create(:folder, :password_protected => true, :password => "password", :password_confirmation => "password")
            expect(folder.valid_password?("faksakdas")).to_not be(true)
        end

        it "saves the password for the folder when password_protected is true and validates the password" do
            folder = create(:folder, :password_protected => true, :password => "password", :password_confirmation => "password")
            expect(folder.valid_password?("password")).to be(folder)
        end
    end
end
