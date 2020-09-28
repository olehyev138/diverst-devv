RSpec.shared_examples 'it Contains Field Data' do |*input|
  it { is_expected.to be_a_kind_of(ContainsFieldData) }
  it 'has a field_definer_name' do
    expect(described_class::FIELD_DEFINER_NAME).to be_a(Symbol)
    expect(described_class::FIELD_ASSOCIATION_NAME).to be_a(Symbol)
  end

  describe 'field holder getters' do
    let(:fields) { create_list :field, 3 }
    let(:parent) { create described_class::FIELD_DEFINER_NAME.to_sym, fields: fields }
    let(:child) { create described_class.model_name.param_key, described_class::FIELD_DEFINER_NAME.to_sym => parent }

    it 'has a field_definer method' do
      expect(child).to respond_to(:field_definer)
      expect(child.field_definer).to eq(parent)
    end

    it 'has a field_definer_id method' do
      expect(child).to respond_to(:field_definer_id)
      expect(child.field_definer_id).to eq(parent.id)
    end

    it 'field_definer has fields' do
      expect(child.fields).to all(be_a(Field))
    end
  end

  describe 'required validations' do
    let!(:required_field) { create :field, required: true }
    let!(:not_required_field) { create :numeric_field, required: false, min: 0, max: 10 }
    let!(:parent) { create described_class::FIELD_DEFINER_NAME.to_sym, fields: [required_field, not_required_field] }
    let!(:child) { create described_class.model_name.param_key, described_class::FIELD_DEFINER_NAME.to_sym => parent }

    before do
      parent.create_missing_field_data
      child.reload
    end

    it 'will be valid if field data is untouched' do
      child.created_at = 1.hour.ago
      expect(child.valid?).to be(true)
      expect(child.errors.size).to be(0)
    end

    it 'will not be valid if field data is touched' do
      skip "don't know how to handle typed fields in tests" if parent.class.get_association('fields').scope.present?
      child.field_data_attributes = [{ field_id: not_required_field.id, data: 5 }]
      expect(child.valid?).to be(false)
      expect(child.errors.full_messages.first.downcase).to eq("#{required_field.title.to_s.downcase.gsub(/[^\w ]/, '')} can't be blank")
    end
  end
end
