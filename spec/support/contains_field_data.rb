RSpec.shared_examples 'it Contains Field Data' do |*input|
  it {
    is_expected.to be_a_kind_of(ContainsFieldData)
  }
  it 'has a field_definer_name' do
    expect(described_class.class_variable_get(:@@field_definer_name)).to be_a(String)
    expect(described_class.class_variable_get(:@@field_association_name)).to be_a(String)
    expect(described_class).to respond_to(:field_definer_name)
    expect(described_class).to respond_to(:field_association_name)
    expect(described_class.field_definer_name).to be_a(String)
  end

  describe 'field holder getters' do
    let(:fields) { create_list :field, 3 }
    let(:parent) { create described_class.field_definer_name.to_sym, fields: fields }
    let(:child) { create described_class.model_name.param_key, described_class.field_definer_name.to_sym => parent }

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
