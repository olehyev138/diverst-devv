require 'rails_helper'

RSpec.describe ThemeCompilerJob, type: :job do
  let!(:enterprise) { create(:enterprise) }
  let!(:theme) { create(:theme, enterprise: enterprise) }

  it 'calls set_default_policy_group on the user' do
    expect_any_instance_of(ThemeCompiler).to receive(:compute)
    subject.perform(theme.id, enterprise.id)
  end
end
