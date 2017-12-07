require 'rails_helper'

RSpec.describe Website::LeadsController, type: :controller do

    describe "POST#create" do
        before { post :create, :name => "test", :visitor_info => {:city => "test"}, format: :json }
        
        it "returns response in json" do
            expect(response.content_type).to eq "application/json"
        end

        it "expect request filtered parameters" do 
        	filtered_params = {"name"=>"test", "visitor_info"=>{"city"=>"test"}, "format"=>"json", "controller"=>"website/leads", "action"=>"create"}
        	expect(request.filtered_parameters).to eq filtered_params
        end
    end
end