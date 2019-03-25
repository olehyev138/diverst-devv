require 'rails_helper'

RSpec.describe ArchivedInitiativesController, type: :controller do
	let!(:enterprise) { create(:enterprise) }
	let!(:user) { create(:user, enterprise: enterprise) }
	let!(:group) { create(:group, enterprise: enterprise) }
	let!(:archived_initiatives) { create_list(:initiative, 2, archived_at: DateTime.now, owner_group: group) }

	describe 'GET#index' do 

		context 'when logged in' do 
			login_user_from_let
			before { get :index }

			it 'returns archived initiatives' do 
				expect(assigns[:initiatives]).to eq archived_initiatives
			end

			it 'renders index template' do 
				expect(response).to  render_template(:index)
			end
		end
	end

	describe 'DELETE#destroy' do 

		context 'when logged in' do 
			login_user_from_let
			before { request.env['HTTP_REFERER'] = 'back' }

			it 'deletes archived initiative' do 
				expect{ delete :destroy, id: archived_initiatives.first.id }.to change(Initiative, :count).by(-1)
			end
		end
	end

	describe 'POST#delete_all' do 

		context 'when logged in' do 
			login_user_from_let
			before { request.env['HTTP_REFERER'] = 'back' }

			it 'deletes all archived initiatives' do 
				expect{ post :delete_all }.to change(Initiative, :count).by(-2)
			end
		end
	end

	describe 'POST#restore_all' do 
		
		context 'when logged in' do
			login_user_from_let
			before { request.env['HTTP_REFERER'] = 'back' }

			it 'restores all archived initiatives' do 
				expect{ post :restore_all }.to change(Initiative.archived_initiatives(enterprise), :count).by(-2)
			end
		end
	end

	describe 'PATCH#restore' do 

		context 'when logged in' do 
			login_user_from_let
			before { request.env['HTTP_REFERER'] = 'back' }

			it 'restores an archived initiative' do 
				expect{ patch :restore, id: archived_initiatives.first.id }.to change(Initiative.archived_initiatives(enterprise), :count).by(-1)
			end
		end
	end
end
