require 'rails_helper'

RSpec.describe Integrations::YammerController, type: :controller do
    
    let(:user) { create :user }
    
    describe 'GET#login' do
        it "redirects" do
            get :login
            expect(response).to redirect_to YammerClient.webserver_authorization_url
        end
    end
    
end
