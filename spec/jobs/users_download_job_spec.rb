require 'rails_helper'

RSpec.describe UsersDownloadJob, type: :job do
    include ActiveJob::TestHelper

    let(:enterprise) { create(:enterprise) }
    let(:user) { create(:user, :enterprise => enterprise) }


    describe "#perform" do
        
    	context "for all users" do 
	        it "creates a downloadable csv file for all users" do
    	        expect{ subject.perform(user.id, "all_users") }
        	      .to change(CsvFile, :count).by(1)
        	end

        	it "file name is all_users.csv" do 
        		subject.perform(user.id, "all_users")
        		expect(CsvFile.last.download_file_file_name).to eq "all_users.csv"
        	end
        end

        context "for all active users" do
	        it "creates a downloadable csv file for only active users" do
    	        expect{ subject.perform(user.id, "active_users") }
        	      .to change(CsvFile, :count).by(1)
        	end

        	it "file name is active_users.csv" do 
        		subject.perform(user.id, "active_users")
        		expect(CsvFile.last.download_file_file_name).to eq "active_users.csv"
        	end
        end

        context "for all inactive users" do 
        	it "creates a downloadable csv file for inactive users" do
            	expect{ subject.perform(user.id, "inactive_users") }
              	.to change(CsvFile, :count).by(1)
        	end

        	it "file name is inactive_users.csv" do 
        		subject.perform(user.id, "inactive_users")
        		expect(CsvFile.last.download_file_file_name).to eq "inactive_users.csv"
        	end
        end

        context "for all group leaders" do 
	        it "creates a downloadable csv file for group leaders" do
	            expect{ subject.perform(user.id,  "group_leaders") }
	              .to change(CsvFile, :count).by(1)
	        end

	        it "file name is group_leaders.csv" do 
        		subject.perform(user.id, "group_leaders")
        		expect(CsvFile.last.download_file_file_name).to eq "group_leaders.csv"
        	end
	    end
    end
end
