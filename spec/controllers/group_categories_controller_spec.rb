require 'rails_helper'

RSpec.describe GroupCategoriesController, type: :controller do
	let!(:enterprise){ create(:enterprise, cdo_name: "test") }
	let!(:parent) { create(:group, enterprise: enterprise) }
	let!(:group) { create(:group, enterprise: enterprise, parent: parent) }
	let!(:main_category) { create(:group_category_type, enterprise_id: enterprise.id) }
	let!(:group_category1) { create(:group_category, name: "category 1", enterprise_id: enterprise.id, group_category_type_id: main_category.id) }
	let!(:group_category2) { create(:group_category, name: "category 2", enterprise_id: enterprise.id, group_category_type_id: main_category.id) }
	let!(:user) { create(:user, enterprise: enterprise) }

	describe 'GET#index' do
		login_user_from_let
		before { get :index, { parent_id: parent.id, group_id: group.id  } }

		it 'render index template' do
			expect(response).to render_template :index
		end

		it 'returns 2 categories' do
			expect(assigns[:categories].count).to eq 2
		end

		it 'returns parent object via params' do
			expect(assigns[:parent]).to eq Group.find(controller.params[:parent_id].to_i)
		end
	end

	describe 'GET#new' do
    	login_user_from_let
    	before { get :new, { group_id: group } }

    	it 'render new template' do
    		expect(response).to render_template :new
    	end

    	it 'returns new group_category_type object' do
    		expect(assigns[:group_category_type]).to be_a_new(GroupCategoryType)
    	end
	end

	describe 'POST#create' do
		login_user_from_let

		context 'if group_category_type object is saved' do
			it 'creates a category type' do
				expect{post :create, group_category_type: FactoryGirl.attributes_for(:group_category_type)}
				.to change(GroupCategoryType, :count).by(1)
			end

			it 'flashes a notice' do
				post :create, group_category_type: FactoryGirl.attributes_for(:group_category_type)
				expect(flash[:notice]).to eq "you just created a category named #{GroupCategoryType.last}"
			end

			it 'redirects to groups_url' do
				post :create, group_category_type: FactoryGirl.attributes_for(:group_category_type)
				redirect_to groups_url
			end
		end

		context 'if group_category_type object fails to save' do
			it 'flashes an alert message' do
				post :create, group_category_type: {name: nil}
				expect(flash[:alert]).to eq "something went wrong. Please check errors."
		    end

		    it 'render new template' do
				post :create, group_category_type: {name: nil}
		    	expect(response).to render_template :new
		    end
		end
	end

	describe "GET#edit" do
		login_user_from_let
		before { get :edit, id: group_category1.id }

		it 'renders edit template' do
			expect(response).to render_template :edit
		end

		it 'returns valid category object' do
			expect(assigns[:category]).to be_valid
		end
	end

	describe "PATCH#update" do
		login_user_from_let

		context "when update is successful" do
		  before { patch :update, id: group_category2.id, group_category: { name: "updated group category2" }  }

		  it 'flashes a notice message' do
		  	expect(flash[:notice]).to eq "update category name"
		  end

		  it 'redirects to view_all_group_categories_url' do
		  	expect(response).to redirect_to view_all_group_categories_url
		  end

		  it 'updates category' do
		  	expect(assigns[:category].name).to eq "updated group category2"
		  end
		end
	end

	describe "DELETE#destroy" do
		login_user_from_let
		before { request.env["HTTP_REFERER"] = "back" }

		it 'destroys group category object' do
			expect{delete :destroy, id: group_category2.id}.to change(GroupCategory, :count).by(-1)
		end

		it 'flashes a notice message' do
			delete :destroy, id: group_category2.id
			expect(flash[:notice]).to eq "Category successfully removed."
		end

		it 'redirects to back' do
			delete :destroy, id: group_category2.id
			expect(response).to redirect_to "back"
		end
	end

	describe "POST#update_all_sub_groups" do
		login_user_from_let
		let!(:parent_group) { create(:group, name: "Parent Group", enterprise_id: enterprise.id, parent_id: nil) }
		let!(:sub_group1) { create(:group, name: "Sub-Group1", enterprise_id: enterprise.id, parent_id: parent_group.id) }
		let!(:sub_group2) { create(:group, name: "Sub-Group2", enterprise_id: enterprise.id, parent_id: parent_group.id) }

		before do
			request.env["HTTP_REFERER"] = "back"
			params = { "children" =>{"#{sub_group1.id}"=>{"group_category_id"=>"#{group_category1.id}"}, "#{sub_group2.id}"=>{"group_category_id"=>"#{group_category2.id}"}} }
			post :update_all_sub_groups, params
		end

		it 'updates all sub_groups with group categories and group type' do
			parent = assigns[:parent]
			parent.children.each do |sub_group|
				expect(sub_group.group_category.id).not_to be_nil
				expect(sub_group.group_category_type_id).not_to be_nil
			end
		end

		it 'return parent of all sub-groups being updated' do
			expect(assigns[:parent]).to eq parent_group
		end

		it 'flashes a notice message' do
			expect(flash[:notice]).to eq "Categorization successful"
		end

		it 'redirect to back' do
			expect(response).to redirect_to "back"
		end
	end

	describe "GET#view_all" do
		login_user_from_let
		let!(:category_types) { create_list(:group_category_type, 3, enterprise_id: enterprise.id) }
		before { get :view_all }

		it 'renders view all page' do
			expect(response).to render_template :view_all
		end

		it 'returns categories of an enterprise' do
			expect(assigns[:categories].count).to eq 2
		end

		it 'returns 3 category types' do
			expect(assigns[:category_types].count).to eq 4
		end
	end
end
