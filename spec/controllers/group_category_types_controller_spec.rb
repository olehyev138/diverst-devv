require 'rails_helper'

RSpec.describe GroupCategoryTypesController, type: :controller do
	let!(:enterprise){ create(:enterprise, cdo_name: "test") }
	let!(:group_category_type) { create(:group_category_type, name: "category type 1", enterprise_id: enterprise.id) }
	let!(:group_category1) { create(:group_category, name: "category 1", enterprise_id: enterprise.id, group_category_type_id: group_category_type.id) }
	let!(:group_category2) { create(:group_category, name: "category 2", enterprise_id: enterprise.id, group_category_type_id: group_category_type.id) }
	let!(:user) { create(:user, enterprise: enterprise) }

	describe "GET#edit" do
		login_user_from_let
		before { get :edit, id: group_category_type.id }

		it 'renders edit template' do
			expect(response).to render_template :edit
		end

		it 'return valid category type object' do
			expect(assigns[:category_type]).to be_valid
		end
	end

	describe "PATCH#update" do
		login_user_from_let

		context "when update is successful" do
		  before { patch :update, id: group_category_type.id, group_category_type: { name: "updated group category type 2" }  }

		  it 'flashes a notice message' do
		  	expect(flash[:notice]).to eq "update category type name"
		  end

		  it 'redirects to view_all_group_categories_url' do
		  	expect(response).to redirect_to view_all_group_categories_url
		  end

		  it 'updates category' do
		  	expect(assigns[:category_type].name).to eq "updated group category type 2"
		  end
		end
	end

	describe "DELETE#destroy" do
		login_user_from_let
		before { request.env["HTTP_REFERER"] = "back" }

		it "destroys group category type object" do
			expect{delete :destroy, id: group_category_type.id}.to change(GroupCategoryType, :count).by(-1)
		end

		it 'flashes a notice message' do
			delete :destroy, id: group_category_type.id
			expect(flash[:notice]).to eq "Successfully deleted categories"
		end

		it 'redirects to back' do
			delete :destroy, id: group_category_type.id
			expect(response).to redirect_to "back"
		end
	end

	describe "GET#add_category" do 
		login_user_from_let
		before {get :add_category, id: group_category_type.id }

		it 'renders add_category template' do 
			expect(response).to render_template :add_category
		end

		it 'returns a valid group category type object' do 
			expect(assigns[:category_type]).to be_valid
		end
	end
end
