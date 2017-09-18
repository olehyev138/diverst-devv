require 'rails_helper'

RSpec.describe SubSegmentsController, type: :controller do
    let(:enterprise){ create(:enterprise, cdo_name: "test") }
    let(:user){ create(:user, enterprise: enterprise) }
    let(:segment){ create(:segment, enterprise: enterprise) }
    
    login_user_from_let
    
    describe "POST#create" do
        before{ post :create, :segment_id => segment.id, :segment => {:name => "test"}}
        it "redirects" do
            expect(response).to redirect_to segment
        end
        
        it "creates segment" do
            last_segment = Segment.last
            expect(last_segment.name).to eq("test")
        end
        
        it "flashes" do
            expect(flash[:notice])
        end
        
        it "increments sub_segments count" do
            expect(segment.sub_segments.count).to eq(1)
        end
        
        it "sets parent and child relationship" do
            child = Segment.last
            
            expect(child.parent.id).to eq(segment.id)
        end
    end
    
    describe "GET#new" do
        it "returns success" do
            get :new, :segment_id => segment.id
            expect(response).to be_success
        end
    end

end
