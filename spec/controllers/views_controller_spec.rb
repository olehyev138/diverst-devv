require 'rails_helper'

RSpec.describe ViewsController, type: :controller do
    
    let(:enterprise) { create(:enterprise) }
    let(:user) { create(:user, enterprise: enterprise) }
    let(:group) { create(:group, enterprise: enterprise) }
    
    describe "POST#track" do
        context 'when user is logged in' do
            login_user_from_let

            it "increments the view count" do
                post :track, :view => {:user_id => user.id, :enterprise_id => user.enterprise_id, :group_id => group.id}
                group.reload
                
                expect(group.total_views).to eq(1)
            end
        end

        context 'when user is not logged in' do
            before { post :track, :view => {:user_id => user.id, :enterprise_id => user.enterprise_id, :group_id => group.id } }
            it_behaves_like "redirect user to users/sign_in path"
        end
    end
end
