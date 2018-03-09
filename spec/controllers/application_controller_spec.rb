require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do

    let(:user){ create(:user) }
    login_user_from_let

    controller do 
    	def index
    		raise ActiveRecord::RecordNotFound
    	end
    end

    describe "#rescue_from " do
    	before do
    		request.env["HTTP_REFERER"] = "back"
    		allow(Rails).to receive(:env) { "production".inquiry }
        	get :index
    	end

        it 'flashes an alert message' do 
        	expect(flash[:alert]).to eq "Sorry, the resource you are looking for does not exist."
        end

        it 'redirects to previous page' do 
        	expect(response).to redirect_to "back"
        end
    end
end