require 'rails_helper'

RSpec.describe GroupCategoriesController, type: :controller do
	let!(:enterprise){ create(:enterprise, cdo_name: "test") }
	let!(:parent) { create(:group, enterprise: enterprise) }
	let!(:group) { create(:group, enterprise: enterprise, parent: parent) }
	let!(:group_category1) { create(:group_category, name: "category 1") } 
	let!(:group_category2) { create(:group_category, name: "category 2") } 
	let!(:user) { create(:user) }

	describe 'GET#index' do
		login_user_from_let
		before { get :index, { parent_id: parent.id, group_id: group.id  } }

		it 'render index template' do 
			expect(response).to render_template :index
		end

		it 'returns 2 categories' do 
			expect(assigns[:categories].count).to eq 2
		end

		it 'returns parent and group object via params' do 
			expect(assigns[:parent]).to eq Group.find(controller.params[:parent_id].to_i) 
			expect(assigns[:group]).to eq Group.find(controller.params[:group_id].to_i)
		end
	end

	describe 'GET#new' do
    	login_user_from_let
    	before { get :new, { group_id: group } }

    	it 'render new template' do 
    		expect(response).to render_template :new
    	end

    	it 'returns group from controller params' do 
    		expect(assigns[:group]).to eq Group.find(controller.params[:group_id].to_i) 
    	end

    	it 'returns new group_category_type object' do 
    		expect(assigns[:group_category_type]).to be_a_new(GroupCategoryType)
    	end
	end

	describe 'POST#create' do 
		login_user_from_let

		it 'returns group from controller params' do
			post :create, group_category_type: FactoryGirl.attributes_for(:group_category_type), group_category_type: { group_id: group.id } 
			expect(assigns[:group]).to eq Group.find(controller.params[:group_category_type][:group_id].to_i)
		end

		xcontext 'if group_category_type object is saved' do
			it 'creates a category type' do 
				expect{post :create, group_category_type: {name: "Region"}, group_category_type: { group_id: group }}
				.to change(GroupCategoryType, :count).by(1)
			end

			it 'flashes a notice' do
				post :create, group_category_type: {name: "Region"}, group_category_type: { group_id: group.id }
				expect(flash[:notice]).to eq "you just created a category named"
			end

			it 'redirects to group_categories_url' do 
				post :create, group_category_type: {name: "Region"}, group_category_type: { group_id: group.id }
				recirect_to group_categories_url()
			end
		end

		context 'if group_category_type object fails to save' do 
			it 'flashes an alert message' do 
				post :create, group_category_type: {name: nil}, group_category_type: { group_id: group }
				expect(flash[:alert]).to eq "something went wrong. Please check errors."
		    end

		    it 'render new template' do 
				post :create, group_category_type: {name: "Region"}, group_category_type: { group_id: group }
		    	expect(response).to render_template :new
		    end
		end
	end

	xdescribe 'POST#update_all_groups' do 
		login_user_from_let 

		it 'flashes notice message' do 
			post :update_all_groups
		end
	end
end
