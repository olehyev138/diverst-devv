require 'rails_helper'

RSpec.describe Field do
  describe "when validating" do
    let(:field){ build(:field, container: build(:enterprise)) }
    let(:field1) { build(:field, container: build(:segments_field)) }

    context 'validate presence of title for field' do
      it 'valid if title is present' do
        field.title = "title"
        expect(field).to be_valid
      end

      it 'invalid if title is absent' do
        field.title = ""
        expect(field).not_to be_valid
      end
    end

    context 'validate presence of title for field1' do
      it 'valid if title is present' do
        field1.title = "title"
        expect(field1).to be_valid
      end

      it 'valid if title is absent' do
        field1.title = ""
        expect(field1).not_to be_valid
      end
    end
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
    let!(:field){ create(:field, container: create(:enterprise)) }

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
end
