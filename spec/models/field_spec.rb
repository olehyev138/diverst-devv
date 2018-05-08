require 'rails_helper'

RSpec.describe Field do
  describe "when validating" do
    let(:field){ build_stubbed(:field) }

    it { expect(field).to validate_presence_of(:title) }
  end

  describe ".numeric?" do
    context "when field is Numeric" do
      let(:numeric_field){ build_stubbed(:numeric_field) }

      it "returns true" do
        expect(numeric_field.numeric?).to eq true
      end
    end

    context "when field is not Numeric" do
      let(:non_numeric_field){ build_stubbed(:select_field) }

      it "returns false" do
        expect(non_numeric_field.numeric?).to eq false
      end
    end
  end

  describe 'when describing callbacks' do
    let!(:field){ create(:field, enterprise: create(:enterprise)) }

    it "should reindex users on elasticsearch after update" do
      TestAfterCommit.with_commits(true) do
        expect(RebuildElasticsearchIndexJob).to receive(:perform_later).with(
          model_name: 'User',
          enterprise: field.enterprise
        )
        field.update(title: 'Field')
      end
    end

    it "should reindex users on elasticsearch after destroy" do
      TestAfterCommit.with_commits(true) do
        expect(RebuildElasticsearchIndexJob).to receive(:perform_later).with(
          model_name: 'User',
          enterprise: field.enterprise
        )
        field.destroy
      end
    end
  end
  
  describe "#string_value" do
    it "Returns a well-formatted string representing the value. Used for display." do
      field = create(:field)
      expect(field.string_value("test")).to eq("test")
    end
  end
  
  describe "#destroy_callbacks" do
    it "removes the child objects" do
      field = create(:field)
      yammer_field_mapping = create(:yammer_field_mapping, :diverst_field => field)
      
      field.destroy!
      
      expect{Field.find(field.id)}.to raise_error(ActiveRecord::RecordNotFound)
      expect{YammerFieldMapping.find(yammer_field_mapping.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
