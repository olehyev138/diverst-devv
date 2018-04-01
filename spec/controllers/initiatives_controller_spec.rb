require 'rails_helper'

RSpec.describe InitiativesController, type: :controller do
  let(:user) { create :user }
  let!(:group) { create :group, enterprise: user.enterprise }
  let(:outcome) {create :outcome, group_id: group.id}
  let(:pillar) { create :pillar, outcome_id: outcome.id}
  let(:initiative) { create :initiative, pillar: pillar, owner_group: group}

  describe 'GET #index' do
    def get_index(group_id = -1)
      get :index, group_id: group_id
    end

    context 'with logged user' do
      login_user_from_let
      before { get_index(group.id) }

      it 'render index template' do
        expect(response).to render_template :index
      end

      it "display group outcomes" do
        expect(assigns[:outcomes]).to eq [outcome]
      end
    end

    context 'without logged user' do
      before { get_index(group.id) }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe 'GET #new' do
    def get_new(group_id = -1)
      get :new, group_id: group_id
    end

    context 'with logged user' do
      login_user_from_let
      before { get_new(group.id) }

      it 'assigns new group' do
        expect(assigns(:initiative)).to be_new_record
      end

      it 'assigns segments of enterprise' do
        expect(assigns(:segments)).to eq user.enterprise.segments
      end
    end

    context 'without logged user' do
      before { get_new(group.id) }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe 'GET #show' do
    def get_show
      get :show, :group_id => group.id, :id => initiative.id
    end

    context 'with logged user' do
      login_user_from_let

      let!(:update_1) { create(:initiative_update, initiative: initiative, created_at: Time.now - 1.days) }
      let!(:update_2) { create(:initiative_update, initiative: initiative, created_at: Time.now - 8.hours) }
      let!(:update_3) { create(:initiative_update, initiative: initiative, created_at: Time.now) }

      before do
        get_show
      end

      it 'returns 3 group updates' do
        expect(assigns[:updates].count).to eq 3
      end

      context "returns group updates belonging to the right initiative" do
        it "for first update" do
          expect(update_1.initiative).to eq initiative
        end

        it "for second update" do
          expect(update_2.initiative).to eq initiative
        end

        it "for last update" do
          expect(update_3.initiative).to eq initiative
        end
      end

      it "returns updates in ascending order of created_at, and at a limit of 3" do
        create_list(:initiative_update, 2, initiative: initiative) #create 2 more to make a total of 5 updates
        expect(assigns[:updates]).to eq [update_1, update_2, update_3]
        expect(InitiativeUpdate.count).to eq 5
        expect(assigns[:updates].count).to eq 3
      end

      it "render template show" do
        expect(response).to render_template :show
      end
    end

    context 'without logged user' do
      before { get_show }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe 'GET #edit' do
    before { pillar }
    let!(:group) { create :group, :with_outcomes, enterprise: user.enterprise }
    let!(:initiative) { create :initiative, owner_group: group, pillar: pillar }

    #TODO this is bad. We need to associate group with initiatives directly
    # before { group.outcomes.first.pillars.first.initiatives << initiative }

    def get_edit(group_id = -1, initiative_id = -1)
      get :edit, group_id: group_id, id: initiative_id
    end

    context 'with logged user' do
      login_user_from_let
      before { get_edit(group.id, initiative.id) }

      it 'render edit template' do
        expect(response).to render_template :edit
      end

      it "returns a valid initiative object" do
        expect(assigns[:initiative]).to be_valid
      end

      it 'sets initiative' do
        expect(assigns(:initiative)).to eq initiative
      end

      it 'assigns segments of enterprise' do
        expect(assigns(:segments)).to eq user.enterprise.segments
      end
    end

    context 'without logged user' do
      before { get_edit(group.id, initiative.id) }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe "GET#attendees" do
    let!(:group) { create :group, :with_outcomes, enterprise: user.enterprise }
    let!(:initiative) { create :initiative, owner_group: group }
    let!(:attendee) { create(:user) }

    context 'with logged in user' do
      login_user_from_let
      before { initiative.update(attendees: [attendee]) }


      it "render a csv file" do
        get :attendees, group_id: group.id, id: initiative.id
        expect(response.headers["Content-Type"]).to eq "text/csv"
      end

      it "render a csv with attendees of an initiative" do
        get :attendees, group_id: group.id, id: initiative.id
        expect(response.body.split("\n")[1]).to eq "#{ attendee.first_name },#{ attendee.last_name },#{ attendee.email },#{ attendee.biography },#{attendee.active}"
      end
    end

    context "without a logged in user" do
      before { get :attendees, group_id: group.id, id: initiative.id }
      it_behaves_like "redirect user to users/sign_in path"
    end
  end


  describe 'non-GET' do
    let!(:group) { create :group, :with_outcomes, enterprise: user.enterprise }
    let!(:initiative) { build :initiative, owner_group: group }

    describe 'POST #create' do
      def post_create(group_id = -1, params = {})
        post :create, group_id: group_id, initiative: params
      end

      context 'with logged in user' do
        login_user_from_let

        context 'with correct params' do
          let(:initiative_attrs) { attributes_for :initiative }

          it 'creates initiative' do
            expect{
              post_create(group.id, initiative_attrs)
            }.to change(Initiative, :count).by(1)
          end

          it 'creates correct initiative' do
            post_create(group.id, initiative_attrs)

            new_initiative = Initiative.last

            expect(new_initiative.owner).to eq user
            expect(new_initiative.owner_group).to eq group

            expect(new_initiative.name).to eq initiative_attrs[:name]
            expect(new_initiative.description).to eq initiative_attrs[:description]
            expect(new_initiative.location).to eq initiative_attrs[:location]
            expect(new_initiative.start).to be_within(1).of initiative_attrs[:start]
            expect(new_initiative.end).to be_within(1).of initiative_attrs[:end]
          end

          it 'assigns segments of enterprise' do
            post_create(group.id, initiative_attrs)
            expect(assigns(:segments)).to eq user.enterprise.segments
          end

          describe 'public activity' do
            enable_public_activity

            it 'creates public activity record' do
              expect{
                post_create(group.id, initiative_attrs)
              }.to change(PublicActivity::Activity, :count).by(1)
            end

            describe 'activity record' do
              let(:model) { Initiative.last }
              let(:owner) { user }
              let(:key) { 'initiative.create' }

              before {
                post_create(group.id, initiative_attrs)
              }

              include_examples'correct public activity'
            end
          end

          it 'redirects to correct page' do
            post_create(group.id, initiative_attrs)
            expect(response).to redirect_to action: :index
          end

          it "flashes a notice message" do
            post_create(group.id, initiative_attrs)
            expect(flash[:notice]).to eq "Your event was created"
          end
        end

        context 'with incorrect params' do
          it 'does not save the new initiative' do
            expect{ post_create(group.id, initiative: { start: nil }) }
              .to_not change(Initiative, :count)
          end

          it 'renders new view' do
            post_create(group.id, initiative: {})
            expect(response).to render_template :new
          end

          it 'assigns segments of enterprise' do
            post_create(group.id, initiative: {})
            expect(assigns(:segments)).to eq user.enterprise.segments
          end

          it "flashes an alert message" do
            post_create(group.id, initiative: {})
            expect(flash[:alert]).to eq "Your event was not created. Please fix the errors"
          end
        end
      end

      context 'without logged in user' do
        before { post_create(group.id) }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end


    describe 'PATCH #update' do
      def patch_update(group_id = -1, id= -1, params = {})
        patch :update, group_id: group_id, id: id, initiative: params
      end

      let!(:initiative) { create :initiative, owner_group: group }

      context 'with logged in user' do
        login_user_from_let

        context 'with correct params' do
          let(:initiative_attrs) { attributes_for :initiative }

          it 'updates fields' do
            patch_update(group.id, initiative.id, initiative_attrs)

            updated_initiative = Initiative.find(initiative.id)

            expect(updated_initiative.name).to eq initiative_attrs[:name]
            expect(updated_initiative.description).to eq initiative_attrs[:description]
            expect(updated_initiative.location).to eq initiative_attrs[:location]
            expect(updated_initiative.start).to be_within(1).of initiative_attrs[:start]
            expect(updated_initiative.end).to be_within(1).of initiative_attrs[:end]
          end

          it "flashes a notice messgae" do
            patch_update(group.id, initiative.id, initiative_attrs)
            expect(flash[:notice]).to eq "Your event was updated"
          end

          it 'assigns segments of enterprise' do
            patch_update(group.id, initiative.id, initiative_attrs)
            expect(assigns(:segments)).to eq user.enterprise.segments
          end

          describe 'public activity' do
            enable_public_activity

            it 'creates public activity record' do
              expect{
                patch_update(group.id, initiative.id, initiative_attrs)
              }.to change(PublicActivity::Activity, :count).by(1)
            end

            describe 'activity record' do
              let(:model) { Initiative.last }
              let(:owner) { user }
              let(:key) { 'initiative.update' }

              before {
                patch_update(group.id, initiative.id, initiative_attrs)
              }

              include_examples'correct public activity'
            end
          end

          it 'redirects to correct page' do
            patch_update(group.id, initiative.id, initiative_attrs)
            expect(response).to redirect_to [group, :initiatives]
          end
        end

        context 'with incorrect params' do
          before { patch_update(group.id, initiative.id, { start: nil }) }

          it 'does not update initiative' do
            updated_initiative = Initiative.find(initiative.id)

            expect(updated_initiative.name).to eq initiative.name
            expect(updated_initiative.description).to eq initiative.description
            expect(updated_initiative.location).to eq initiative.location
            expect(updated_initiative.start).to be_within(1).of initiative.start
            expect(updated_initiative.end).to be_within(1).of initiative.end
          end

          it 'renders edit view' do
            expect(response).to render_template :edit
          end

          it 'assigns segments of enterprise' do
            expect(assigns(:segments)).to eq user.enterprise.segments
          end

          it "flashes an alert message" do
            expect(flash[:alert]).to eq "Your event was not updated. Please fix the errors"
          end
        end
      end

      context 'without logged in user' do
        before { patch_update(group.id) }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end


    describe 'DELETE #destroy' do
      def delete_destroy(group_id=-1, id=-1)
        delete :destroy, group_id: group_id, id: id
      end

      let!(:initiative) { create :initiative, owner_group: group }

      context 'with logged in user' do
        login_user_from_let

        context 'with correct params' do
          it 'deletes initiative' do
            expect {
              delete_destroy(group.id, initiative.id)
            }.to change(Initiative, :count).by(-1)
          end

          describe 'public activity' do
            enable_public_activity

            it 'creates public activity record' do
              expect{
                delete_destroy(group.id, initiative.id)
              }.to change(PublicActivity::Activity, :count).by(1)
            end

            describe 'activity record' do
              let(:model) { Initiative.last }
              let(:owner) { user }
              let(:key) { 'initiative.destroy' }

              before {
                delete_destroy(group.id, initiative.id)
              }

              include_examples'correct public activity'
            end
          end

          it 'redirects to correct action' do
            delete_destroy(group.id, initiative.id)
            expect(response).to redirect_to action: :index
          end
        end
      end

      context 'without logged in user' do
        before { delete_destroy(group.id) }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end


    describe 'POST #finish_expenses' do
      def post_finish_expenses(group_id = -1, id= -1)
        post :finish_expenses, group_id: group_id, id: id
      end

      let(:budget) { create :approved_budget, group: group }
      let(:budget_item) { budget.budget_items.first }
      let!(:initiative) { create :initiative, budget_item: budget_item, owner_group: group }

      context 'with logged in user' do
        login_user_from_let

        context 'with correct params' do
          before { post_finish_expenses(group.id, initiative.id) }

          it 'marks initiative as finished' do
            expect(initiative.reload).to be_finished_expenses
          end

          it 'redirects to correct page' do
            expect(response).to redirect_to action: :index
          end
        end
      end

      context "without a logged in user" do
        before { post_finish_expenses(group.id, initiative.id) }
        it_behaves_like "redirect user to users/sign_in path"
      end
    end
  end
end
