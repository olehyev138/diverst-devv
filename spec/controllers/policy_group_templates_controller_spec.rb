require 'rails_helper'

RSpec.describe PolicyGroupTemplatesController, type: :controller do
  include ActiveJob::TestHelper

  let!(:enterprise) { create(:enterprise) }
  let!(:user) { create(:user, enterprise: enterprise) }

  describe 'GET#index' do
    context 'when user is logged in' do
      login_user_from_let
      before { get :index }

      it 'renders index template' do
        expect(response).to render_template :index
      end

      it 'sets the policy_group_templates' do
        expect(assigns[:policy_group_templates].length).to eq(3)
      end
    end

    context 'without logged user' do
      before { get :index }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'GET#edit' do
    context 'when user is logged in' do
      login_user_from_let
      before {
        policy_group_template = enterprise.policy_group_templates.last
        get :edit, id: policy_group_template.id
      }

      it 'render edit template' do
        expect(response).to render_template :edit
      end

      it 'sets a valid policy_group_template object' do
        expect(assigns[:policy_group_template]).to be_valid
      end
    end

    context 'without logged user' do
      before { get :edit, id: policy_group_template.id }
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end

  describe 'PATCH#update' do
    describe 'when user is logged in' do
      login_user_from_let
      let(:policy_group_template) { enterprise.policy_group_templates.last }

      context 'valid params' do
        before do
          patch :update, id: policy_group_template.id, policy_group_template: { campaigns_index: false }
        end

        it 'redirect_to index' do
          expect(response).to redirect_to action: :index
        end

        it 'updates the policy_group_template' do
          policy_group_template.reload
          expect(policy_group_template.campaigns_index).to eq(false)
        end

        describe 'public activity' do
          enable_public_activity

          it 'creates public activity record' do
            perform_enqueued_jobs do
              expect { patch :update, id: policy_group_template.id, policy_group_template: { campaigns_index: false } }
              .to change(PublicActivity::Activity, :count).by(1)
            end
          end

          describe 'activity record' do
            let(:model) { PolicyGroupTemplate.last }
            let(:owner) { user }
            let(:key) { 'policy_group_template.update' }

            before {
              perform_enqueued_jobs do
                patch :update, id: policy_group_template.id, policy_group_template: { campaigns_index: false }
              end
            }

            include_examples 'correct public activity'
          end
        end
      end

      context 'invalid params' do
        before {
          allow_any_instance_of(PolicyGroupTemplate).to receive(:update).and_return(false)
          patch :update, id: policy_group_template.id, policy_group_template: { campaigns_index: nil }
        }

        it 'returns edit' do
          expect(response).to render_template(:edit)
        end

        it "doesn't update the policy_group_template" do
          policy_group_template.reload
          expect(policy_group_template.campaigns_index).to_not be(nil)
        end
      end
    end

    describe 'when user is not logged in' do
      before do
        patch :update, id: policy_group_template.id, policy_group_template: { name: 'updated' }
      end
      it_behaves_like 'redirect user to users/sign_in path'
    end
  end
end
