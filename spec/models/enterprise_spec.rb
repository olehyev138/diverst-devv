require 'rails_helper'

RSpec.describe Enterprise, type: :model do
    
    describe "when validating" do
        let(:enterprise){ create(:enterprise) }

        it { expect(enterprise).to have_many(:rewards) }
        it { expect(enterprise).to have_many(:reward_actions) }
        it { expect(enterprise).to have_many(:badges) }

        it{ expect(enterprise).to have_one(:custom_text) }
    end

    describe "#custom_text" do
        context "when enterprise does not have a custom_text" do
            let!(:enterprise){ create(:enterprise, custom_text: nil) }

            it "create a new custom_text" do
                expect(enterprise.custom_text).to be_an_instance_of(CustomText)
            end
        end

        context "when enterprise have a custom_text" do
            let!(:custom_text){ create(:custom_text) }
            let!(:enterprise){ create(:enterprise, custom_text: custom_text) }

            it "return the custom_text" do
                expect(enterprise.custom_text).to eq custom_text
            end
        end
    end
    
    describe "#default_time_zone" do

        it "returns UTC" do
            enterprise = create(:enterprise, time_zone: nil)
            expect(enterprise.default_time_zone).to eq "UTC"
        end
        
        it "returns EST" do
            enterprise = create(:enterprise, time_zone: "EST")
            expect(enterprise.default_time_zone).to eq "EST"
        end
    end

    describe ".cdo_message_email_html" do
        context "when cdo_message_email is not nil" do
            let(:enterprise){ build_stubbed(:enterprise, cdo_message_email: "test \r\n test") }

            it "change \r\n to br tag" do
                pending 'TODO: Move this check to Decorator, use decorator in views'
                expect(enterprise.cdo_message_email_html).to eq "test <br> test"
            end
        end
    end

    describe '#sso_fields_to_enterprise_fields' do
        let!(:enterprise) { create :enterprise }
        let!(:age_field) { create :field, saml_attribute: 'age' }
        let!(:gender_field) { create :field, saml_attribute: 'gender' }

        let(:saml_fields) {
            {
                'age' => 23,
                'gender' => 'male',
                'department' => 'IT'
            }
        }

        before do
            enterprise.fields << age_field
            enterprise.fields << gender_field
        end

        it 'maps sso fields to existing fields' do
            mapped_fields = enterprise.sso_fields_to_enterprise_fields(saml_fields)

            expect(mapped_fields.length).to eq 2
            expect(mapped_fields).to include(age_field.id => saml_fields['age'])
            expect(mapped_fields).to include(gender_field.id => saml_fields['gender'])

            expect(mapped_fields).to_not have_key 'department'
        end
    end
end
