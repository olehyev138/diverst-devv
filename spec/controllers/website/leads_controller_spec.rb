require 'rails_helper'

RSpec.describe Website::LeadsController, type: :controller do

    describe "GET#new" do
        before {post :create, :name => "test", :visitor_info => {:city => "test"}}
        
        it "renders success" do
            expect(response).to be_success
        end
    end
end