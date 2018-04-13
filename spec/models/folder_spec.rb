require 'rails_helper'

RSpec.describe Folder, type: :model do
    
    describe "when validating" do
        let(:group) { create(:group) }
        let(:folder){ create(:folder, :name => "test", :group => group) }

        it { expect(folder).to have_many(:resources) }
        it { expect(folder).to have_many(:folder_shares) }
        it { expect(folder).to have_many(:groups) }
        
        it{ expect(folder).to belong_to(:group) }
        
        it { expect(folder).to validate_presence_of(:name) }
        #it { expect(folder).to validate_uniqueness_of(:name) } # <- revisit
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
    
    describe '#parent' do
        it "returns nil" do
            folder = create(:folder)
            expect(folder.parent).to be(nil)
        end

        it "returns parent" do
            folder_1 = create(:folder)
            folder_2 = create(:folder, :parent => folder_1)

            expect(folder_2.parent).to_not be(nil)
            expect(folder_2.parent).to eq(folder_1)
        end
    end

    describe '#children' do
        it "returns empty array" do
            folder = create(:folder)
            expect(folder.children.length).to eq(0)
        end

        it "returns 1 child" do
            folder_1 = create(:folder)
            folder_2 = create(:folder, :parent => folder_1)

            expect(folder_1.children).to include(folder_2)
        end
    end
    
    describe '#only_parents' do
        it "returns empty array" do
            expect(Folder.only_parents.length).to eq(0)
        end

        it "returns 1 parent" do
            folder_1 = create(:folder)
            folder_2 = create(:folder, :parent => folder_1)

            expect(Folder.only_parents.length).to eq(1)
        end
    end
end
