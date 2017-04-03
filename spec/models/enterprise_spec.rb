require 'rails_helper'

RSpec.describe Enterprise, type: :model do
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

    let(:saml_fields) {{
      'age' => 23,
      'gender' => 'male',
      'department' => 'IT'
    }}

    before do
      enterprise.fields << age_field
      enterprise.fields << gender_field
    end

    it 'maps sso fields to existing fields' do
      mapped_fields = enterprise.sso_fields_to_enterprise_fields(saml_fields)

      expect(mapped_fields.length).to eq 2
      expect(mapped_fields).to include( age_field.id => saml_fields['age'])
      expect(mapped_fields).to include( gender_field.id => saml_fields['gender'] )

      expect(mapped_fields).to_not have_key 'department'
    end
  end
end
