require 'rails_helper'

RSpec.describe ArchivedPostsController, type: :controller do

  xdescribe "GET #index" do
    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  xdescribe "GET #show" do
    it "returns http success" do
      get :show
      expect(response).to have_http_status(:success)
    end
  end

end
