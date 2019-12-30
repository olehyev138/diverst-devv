RSpec.shared_examples 'it Contains Field Data' do |*input|
  it {
    is_expected.to be_a_kind_of(ContainsFieldData)
  }
  it 'has a fields_holder_name' do
    expect(described_class.class_variable_get(:@@fields_holder_name)).to be_a(String)
    expect(described_class.class_variable_get(:@@field_association_name)).to be_a(String)
    expect(described_class).to respond_to(:fields_holder_name)
    expect(described_class).to respond_to(:field_association_name)
    expect(described_class.fields_holder_name).to be_a(String)
  end

  describe 'field holder getters' do
    let(:fields) { create_list :field, 3 }
    let(:parent) { create described_class.fields_holder_name.to_sym, fields: fields }
    let(:child) { create described_class.model_name.param_key, described_class.fields_holder_name.to_sym => parent }

    it 'has a fields_holder method' do
      expect(child).to respond_to(:fields_holder)
      expect(child.fields_holder).to eq(parent)
    end

    it 'has a fields_holder_id method' do
      expect(child).to respond_to(:fields_holder_id)
      expect(child.fields_holder_id).to eq(parent.id)
    end

    it 'fields_holder has fields' do
      expect(child.fields).to all(be_a(Field))
    end
  end
end
