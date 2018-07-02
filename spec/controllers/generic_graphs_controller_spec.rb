require 'rails_helper'

RSpec.describe GenericGraphsController, type: :controller do
    let(:enterprise) { create(:enterprise, cdo_name: "test") }
    let(:user) { create(:user, enterprise: enterprise, active: true) }
    let!(:field) { create(:field, type: "NumericField", enterprise: enterprise, elasticsearch_only: false) }
    let!(:group) {create(:group, :enterprise => enterprise, :parent_id => nil)}
    let!(:child) {create(:group, :enterprise => enterprise, :parent_id => group.id)}
    let!(:user_group) {create(:user_group, :accepted_member => true, :user => user, :group => group )}
    let!(:segment_1) {create(:segment, :enterprise => enterprise)}
    let!(:segment_2) {create(:segment, :enterprise => enterprise)}
    let!(:segmentation) {create(:segmentation, :parent => segment_1, :child => segment_2)}

    describe "GET#group_population" do
        describe "with logged in user" do
            login_user_from_let

            context "when format is json" do
                before { get :group_population, format: :json }

                it "returns json format" do
                    expect(response.content_type).to eq "application/json"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                context 'returns the correct json data' do
                    let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

                    it 'returns correct title' do
                        expect(json_response[:highcharts][:series][0][:title]).to eq 'Number of users'
                    end

                    it 'returns a count active members of a group' do
                        expect(json_response[:highcharts][:series][0][:data][0][:y]).to eq group.members.active.count
                    end

                    it 'returns name of group' do
                        expect(json_response[:highcharts][:series][0][:data][0][:name]).to eq group.name
                    end

                    it 'returns correct information on categories', skip: "corresponding code has been commented out" do
                        expect(json_response[:highcharts][:categories]).to eq [group.name]
                    end

                    it 'return xAxisTitle to be ERG' do
                        expect(json_response[:highcharts][:xAxisTitle]).to eq 'ERG'
                    end

                    it 'has no aggregation' do
                        expect(json_response[:hasAggregation]).to eq false
                    end
                end
            end

            context "when format is csv" do
                before { get :group_population, format: :csv }

                it "returns csv format" do
                    expect(response.content_type).to eq "text/csv"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                it "return csv filename as 'graph_group_population.csv" do
                    expect(response.headers["Content-Disposition"]).to include 'graph_group_population.csv'
                end
            end
        end

        describe "without a logged in user" do
            context "when format is json" do
                before { get :group_population, format: :json }
                it_behaves_like "redirect user to users/sign_in path"
            end

             context "when format is json" do
                before { get :group_population, format: :csv }
                it_behaves_like "redirect user to users/sign_in path"
            end
        end
    end

    describe "GET#segment_population" do
        describe "with logged in user" do
            login_user_from_let

            context "when format is json" do
                before { get :segment_population, format: :json }

                it "returns json format" do
                    expect(response.content_type).to eq "application/json"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                it "returns correct data" do
                    data = JSON.parse(response.body)
                    expect(data["type"]).to eq("bar")
                    expect(data["highcharts"]["series"][0]["name"]).to eq("Number of users")
                    expect(data["highcharts"]["series"][0]["data"].length).to eq(1)
                    expect(data["highcharts"]["drilldowns"].length).to eq(1)
                    expect(data["highcharts"]["xAxisTitle"]).to eq("Segment")
                    expect(data["hasAggregation"]).to eq(false)
                end
            end

            context "when format is csv" do
                before {get :segment_population, format: :csv}

                it "returns csv format" do
                    expect(response.content_type).to eq "text/csv"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                it "returns csv filename to be 'graph_segment_population.csv'" do
                    expect(response.headers["Content-Disposition"]).to include 'graph_segment_population.csv'
                end
            end
        end

        describe "without a logged in user" do
            context "when format is json" do
                before { get :segment_population, format: :json }
                it_behaves_like "redirect user to users/sign_in path"
            end

             context "when format is json" do
                before { get :segment_population, format: :csv }
                it_behaves_like "redirect user to users/sign_in path"
            end
        end
    end

    describe "GET#events_created" do
        describe "with logged in user" do
            login_user_from_let

            context "when format is json" do
                before { get :events_created, format: :json }

                it "returns json format" do
                    expect(response.content_type).to eq "application/json"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                context 'returns the correct json data' do
                    let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

                    it 'returns correct title' do
                        expect(json_response[:highcharts][:series][0][:title]).to eq 'Events created'
                    end

                    it 'returns a count active members of a group' do
                        expect(json_response[:highcharts][:series][0][:data][0][:y]).to eq group.initiatives.joins(:owner).where('initiatives.created_at > ? AND users.active = ?', 1.month.ago, true).count
                    end

                    it 'returns name of group' do
                        expect(json_response[:highcharts][:series][0][:data][0][:name]).to eq group.name
                    end

                    it 'returns correct information on categories', skip: "corresponding code has been commented out" do
                        expect(json_response[:highcharts][:categories]).to eq [group.name]
                    end

                    it 'return xAxisTitle to be ERG' do
                        expect(json_response[:highcharts][:xAxisTitle]).to eq 'ERG'
                    end

                    it "return yAxisTitle to be 'Nb of events'" do
                        expect(json_response[:highcharts][:yAxisTitle]).to eq 'Nb of events'
                    end

                    it 'has no aggregation' do
                        expect(json_response[:hasAggregation]).to eq false
                    end
                end
            end

            context "when format is csv" do
                before { get :events_created, format: :csv }

                it "returns csv format" do
                    expect(response.content_type).to eq "text/csv"
                end


                it "returns success" do
                    expect(response).to be_success
                end

                it "returns csv filename to be 'graph_events_created.csv'" do
                    expect(response.headers["Content-Disposition"]).to include 'graph_events_created.csv'
                end
            end
        end

        describe "without a logged in user" do
            context "when format is json" do
                before { get :events_created, format: :json }
                it_behaves_like "redirect user to users/sign_in path"
            end

             context "when format is json" do
                before { get :events_created, format: :csv }
                it_behaves_like "redirect user to users/sign_in path"
            end
        end
    end

    describe "GET#messages_sent" do
        describe "with logged in user" do
            login_user_from_let

            context "when format is json" do
                before { get :messages_sent, format: :json }

                it "returns json format" do
                    expect(response.content_type).to eq "application/json"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                context 'returns the correct json data' do
                    let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

                    it 'returns correct title' do
                        expect(json_response[:highcharts][:series][0][:title]).to eq 'Messages sent'
                    end

                    it 'returns a count active members of a group' do
                        expect(json_response[:highcharts][:series][0][:data][0][:y]).to eq group.messages.joins(:owner).where('group_messages.created_at > ? AND users.active = ?', 1.month.ago, true).count
                    end

                    it 'returns name of group' do
                        expect(json_response[:highcharts][:series][0][:data][0][:name]).to eq group.name
                    end

                    it 'returns correct information on categories', skip: "corresponding code has been commented out" do
                        expect(json_response[:highcharts][:categories]).to eq [group.name]
                    end

                    it 'return xAxisTitle to be ERG' do
                        expect(json_response[:highcharts][:xAxisTitle]).to eq 'ERG'
                    end

                    it "return yAxisTitle to be 'Nb of events'" do
                        expect(json_response[:highcharts][:yAxisTitle]).to eq 'Nb of messages'
                    end

                    it 'has no aggregation' do
                        expect(json_response[:hasAggregation]).to eq false
                    end
                end
            end

            context "when format is csv" do
                before { get :messages_sent, format: :csv }

                it "returns csv format" do
                    expect(response.content_type).to eq "text/csv"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                it "returns csv filename to be 'graph_messages_sent.csv'" do
                    expect(response.headers["Content-Disposition"]).to include 'graph_messages_sent.csv'
                end
            end
        end

        describe "without a logged in user" do
            context "when format is json" do
                before { get :messages_sent, format: :json }
                it_behaves_like "redirect user to users/sign_in path"
            end

             context "when format is json" do
                before { get :messages_sent, format: :csv }
                it_behaves_like "redirect user to users/sign_in path"
            end
        end
    end
    
    describe "GET#mentorship" do
        describe "with logged in user" do
            login_user_from_let

            context "when format is json" do
                before { get :mentorship, format: :json }

                it "returns json format" do
                    expect(response.content_type).to eq "application/json"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                context 'returns the correct json data' do
                    let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

                    it 'returns correct title' do
                        expect(json_response[:highcharts][:series][0][:title]).to eq 'Number of mentors/mentees'
                    end

                    it 'returns a count active members of a group' do
                        expect(json_response[:highcharts][:series][0][:data][0][:y]).to eq group.messages.joins(:owner).where('group_messages.created_at > ? AND users.active = ?', 1.month.ago, true).count
                    end

                    it 'returns name of group' do
                        expect(json_response[:highcharts][:series][0][:data][0][:name]).to eq group.name
                    end

                    it 'return xAxisTitle to be ERG' do
                        expect(json_response[:highcharts][:xAxisTitle]).to eq 'ERG'
                    end

                    it "return yAxisTitle to be 'Nb of events'" do
                        expect(json_response[:highcharts][:yAxisTitle]).to be nil
                    end

                    it 'has no aggregation' do
                        expect(json_response[:hasAggregation]).to eq false
                    end
                end
            end

            context "when format is csv" do
                before { get :mentorship, format: :csv }

                it "returns csv format" do
                    expect(response.content_type).to eq "text/csv"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                it "returns csv filename to be 'graph_group_mentorship.csv'" do
                    expect(response.headers["Content-Disposition"]).to include 'graph_group_mentorship.csv'
                end
            end
        end

        describe "without a logged in user" do
            context "when format is json" do
                before { get :mentorship, format: :json }
                it_behaves_like "redirect user to users/sign_in path"
            end

             context "when format is json" do
                before { get :mentorship, format: :csv }
                it_behaves_like "redirect user to users/sign_in path"
            end
        end
    end
    
    describe "GET#mentoring_sessions" do
        describe "with logged in user" do
            login_user_from_let

            context "when format is json" do
                before { get :mentoring_sessions, format: :json }

                it "returns json format" do
                    expect(response.content_type).to eq "application/json"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                context 'returns the correct json data' do
                    let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

                    it 'returns correct title' do
                        expect(json_response[:highcharts][:series][0][:title]).to eq 'Number of mentoring sessions'
                    end

                    it 'returns a count active members of a group' do
                        expect(json_response[:highcharts][:series][0][:data][0][:y]).to eq group.messages.joins(:owner).where('group_messages.created_at > ? AND users.active = ?', 1.month.ago, true).count
                    end

                    it 'returns name of group' do
                        expect(json_response[:highcharts][:series][0][:data][0][:name]).to eq group.name
                    end

                    it 'return xAxisTitle to be ERG' do
                        expect(json_response[:highcharts][:xAxisTitle]).to eq 'ERG'
                    end

                    it "return yAxisTitle to be 'Nb of events'" do
                        expect(json_response[:highcharts][:yAxisTitle]).to be nil
                    end

                    it 'has no aggregation' do
                        expect(json_response[:hasAggregation]).to eq false
                    end
                end
            end

            context "when format is csv" do
                before { get :mentoring_sessions, format: :csv }

                it "returns csv format" do
                    expect(response.content_type).to eq "text/csv"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                it "returns csv filename to be 'graph_group_mentoring_sessions.csv'" do
                    expect(response.headers["Content-Disposition"]).to include 'graph_group_mentoring_sessions.csv'
                end
            end
        end

        describe "without a logged in user" do
            context "when format is json" do
                before { get :mentoring_sessions, format: :json }
                it_behaves_like "redirect user to users/sign_in path"
            end

             context "when format is json" do
                before { get :mentoring_sessions, format: :csv }
                it_behaves_like "redirect user to users/sign_in path"
            end
        end
    end
    
    describe "GET#mentoring_interests" do
        describe "with logged in user" do
            login_user_from_let

            context "when format is json" do
                before { get :mentoring_interests, format: :json }

                it "returns json format" do
                    expect(response.content_type).to eq "application/json"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                context 'returns the correct json data' do
                    let!(:json_response) { JSON.parse(response.body, symbolize_names: true) }

                    it 'returns correct title' do
                        expect(json_response[:highcharts][:series][0][:title]).to eq 'Number of mentoring sessions'
                    end

                    it 'return xAxisTitle to be ERG' do
                        expect(json_response[:highcharts][:xAxisTitle]).to eq 'ERG'
                    end

                    it "return yAxisTitle to be 'Nb of events'" do
                        expect(json_response[:highcharts][:yAxisTitle]).to be nil
                    end

                    it 'has no aggregation' do
                        expect(json_response[:hasAggregation]).to eq false
                    end
                end
            end

            context "when format is csv" do
                before { get :mentoring_interests, format: :csv }

                it "returns csv format" do
                    expect(response.content_type).to eq "text/csv"
                end

                it "returns success" do
                    expect(response).to be_success
                end

                it "returns csv filename to be 'mentoring_interests.csv'" do
                    expect(response.headers["Content-Disposition"]).to include 'mentoring_interests.csv'
                end
            end
        end

        describe "without a logged in user" do
            context "when format is json" do
                before { get :mentoring_interests, format: :json }
                it_behaves_like "redirect user to users/sign_in path"
            end

             context "when format is json" do
                before { get :mentoring_interests, format: :csv }
                it_behaves_like "redirect user to users/sign_in path"
            end
        end
    end
end
