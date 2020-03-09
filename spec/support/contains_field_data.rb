RSpec.shared_examples 'it Contains Field Data' do |*input|
  it {
    is_expected.to be_a_kind_of(ContainsFieldData)
  }
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
end
