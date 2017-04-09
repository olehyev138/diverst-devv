require 'rails_helper'

RSpec.describe EnterprisesController, type: :controller do
  describe "GET#calendar" do
    let!(:enterprise){ create(:enterprise) }

    it "allows view to be embed on iframe" do
      get :calendar, id: enterprise.id
      expect(response.headers).to_not include("X-Frame-Options")
    end

    it "assigns enterprise to @enterprise" do
      get :calendar, id: enterprise.id
      expect(assigns(:enterprise)).to eq enterprise
    end
  end
end
