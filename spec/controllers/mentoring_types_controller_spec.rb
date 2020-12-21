require 'rails_helper'

RSpec.describe MentoringTypesController, type: :controller do
  let(:user) { create :user }
  let(:mentor) { create :user }

  describe 'GET #index' do
    describe 'if user is present' do
      login_user_from_let

      it 'assigns the mentors' do
        get :index
        expect(assigns[:types]).to eq([])
      end
    end
  end

  describe 'GET #new' do
    describe 'if user is present' do
      login_user_from_let

      it 'assigns the type' do
        get :new
        expect(assigns[:type].enterprise_id).to eq(user.enterprise_id)
      end
    end
  end

  describe 'POST #create' do
    describe 'if user is present' do
      login_user_from_let

      context 'when it saves' do
        before { post :create, mentoring_type: { name: 'Test' } }

        it 'creates the type/type' do
          expect(MentoringType.count).to eq(1)
        end

        it 'flashes' do
          expect(flash[:notice]).to eq('Your mentoring type was created')
        end

        it 'redirect_to index' do
          expect(response).to redirect_to action: :index
        end
      end

      context "when it doesn't save" do
        before {
          allow_any_instance_of(MentoringType).to receive(:save).and_return(false)
          post :create, mentoring_type: { name: 'Test' }
        }

        it 'flashes' do
          expect(flash[:alert]).to eq('Your mentoring type was not created. Please fix the errors.')
        end

        it 'does not create the type/type' do
          expect(MentoringType.count).to eq(0)
        end

        it 'redirect_to index' do
          expect(response).to render_template :new
        end
      end
    end
  end

  describe 'GET #edit' do
    describe 'if user is present' do
      login_user_from_let

      it 'assigns the type' do
        type = create(:mentoring_type, enterprise_id: user.enterprise_id)
        get :edit, id: type.id
        expect(assigns[:type].id).to eq(type.id)
      end
    end
  end

  describe 'PUT #update' do
    describe 'if user is present' do
      let(:mentoring_type) { create(:mentoring_type, enterprise_id: user.enterprise.id) }
      login_user_from_let

      before {
        patch :update, id: mentoring_type.id, mentoring_type: { name: 'updated' }
      }

      it 'creates the type and flashes' do
        expect(flash[:notice]).to eq('The mentoring type was updated')
      end

      it 'redirects to index' do
        expect(response).to redirect_to action: :index
      end
    end
  end

  describe 'DELETE #destroy' do
    describe 'if user is present' do
      let(:mentoring_type) { create(:mentoring_type, enterprise_id: user.enterprise.id) }
      login_user_from_let

      before {
        request.env['HTTP_REFERER'] = 'back'
        delete :destroy, id: mentoring_type.id
      }

      it 'destroys the request' do
        expect { MentoringType.find(mentoring_type.id) }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
