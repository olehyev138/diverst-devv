RSpec.shared_examples 'it Defines Fields' do |*input|
  it {
    is_expected.to be_a_kind_of(DefinesFields)
  }
  it 'has a field users' do
    expect(described_class.class_variable_get(:@@field_users)).to be_a(Array)
    expect(described_class).to respond_to(:field_users)
    expect(described_class.field_users).to be_a(Array)
  end

  describe 'field users getters' do
    let(:parent) { build described_class.model_name.singular.to_sym }

    describe 'fields_users associations have field_data' do
      described_class.field_users.each do |f_users|
        it { expect(parent).to have_many(f_users) }
        it { expect(parent.send(f_users)).to all have_many(:field_data) }
      end
    end
  end
end
