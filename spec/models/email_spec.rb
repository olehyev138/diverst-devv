require 'rails_helper'

RSpec.describe Email do
  it { expect(subject).to belong_to :enterprise }
  it { expect(subject).to have_many(:variables).class_name('EmailVariable') }

  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:subject) }
  it { expect(subject).to validate_presence_of(:content) }
  it { expect(subject).to validate_presence_of(:description) }
  it { expect(subject).to validate_presence_of(:mailer_name) }
  it { expect(subject).to validate_presence_of(:mailer_method) }

  it { expect(subject).to validate_length_of(:description).is_at_most(191) }
  it { expect(subject).to validate_length_of(:template).is_at_most(191) }
  it { expect(subject).to validate_length_of(:mailer_method).is_at_most(191) }
  it { expect(subject).to validate_length_of(:mailer_name).is_at_most(191) }
  it { expect(subject).to validate_length_of(:content).is_at_most(65535) }
  it { expect(subject).to validate_length_of(:subject).is_at_most(191) }
  it { expect(subject).to validate_length_of(:name).is_at_most(191) }

  describe 'custom email logic' do
    let(:custom_email) { build_stubbed :custom_email, mailer_name: nil, mailer_method: nil }
    let(:system_email) { build_stubbed :email }

    before do
      custom_email.valid?
      system_email.valid?
    end

    it 'considers custom mailer valid' do
      expect(custom_email).to be_valid
    end

    it 'assigns proper mailer_name before validation' do
      expect(custom_email.mailer_name).to eq Email::CUSTOM_MAILER_MAILER_NAME
    end

    it 'assigns proper mailer_method before validation' do
      expect(custom_email.mailer_method).to eq Email::CUSTOM_MAILER_METHOD_NAME
    end

    it 'does not assign mailer_method or mailer_name for non-custom emails' do
      expect(system_email.mailer_name).to_not eq Email::CUSTOM_MAILER_MAILER_NAME
      expect(system_email.mailer_method).to_not eq Email::CUSTOM_MAILER_METHOD_NAME
    end
  end

  describe '#destroy_callbacks' do
    it 'removes the child objects' do
      email = create(:email)
      email_variable = create(:email_variable, email: email)

      email.destroy

      expect { Email.find(email.id) }.to raise_error(ActiveRecord::RecordNotFound)
      expect { EmailVariable.find(email_variable.id) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#workflow' do
    it 'processes the email' do
      # create the email
      email = create(:email,
                     content: "<p>Hello %{user.name},</p>\r\n\r\n<p>A new item has been posted to a Diversity and Inclusion group you are a member of.
                                 Select the link(s) below to access Diverst and review the item(s)</p>\r\n",
                     subject: 'You have updates in your %{custom_text.erg_text}'
                    )
      create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name'), upcase: true, pluralize: true)
      create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'custom_text.erg_text'), pluralize: true)
      expect(email.valid?).to be(true)

      user = create(:user, first_name: 'Mike', last_name: 'Jone')
      custom_text = create(:custom_text, erg: 'BRG')

      # set the objects containing the information we need
      variables = { user: user, custom_text: custom_text }

      # process the variables and the email content
      mailer_text = email.process_content(variables)

      # ensure the text has been processed correctly
      expect(mailer_text).to include('Hello MIKE JONES')

      # process the variables and the email subject
      subject_text = email.process_subject(variables)

      # ensure the text has been processed correctly
      expect(subject_text).to include('your BRGs')
    end
  end

  describe 'workflow' do
    let(:email) { create(:email,
                         content: "<p>Hello %{user.name},</p>\r\n\r\n<p>A new item has been posted to a Diversity and Inclusion group you are a member of.
                                     Select the link(s) below to access Diverst and review the item(s)</p>\r\n",
                         subject: 'You have updates in your %{custom_text.erg_text}'
                        )
    }
    let(:email_variable1) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'user.name'), upcase: true, pluralize: true) }
    let(:email_variable2) { create(:email_variable, email: email, enterprise_email_variable: create(:enterprise_email_variable, key: 'custom_text.erg_text'), pluralize: true) }

    let(:user) { create(:user, first_name: 'Mike', last_name: 'Jone') }
    let(:custom_text) { create(:custom_text, erg: 'BRG') }
    let(:variables) { { user: user, custom_text: custom_text } }

    describe '#process' do
      it 'returns a hash' do
        expect(email.process(email.content, variables)).to eq('user.name': "#{user.name}")
      end
    end

    describe '#process_content' do
      it 'processes text correctly' do
        expect(email.process_content(variables)).to include('Hello Mike Jone')
      end
    end

    describe '#process_subject' do
      it 'process the variables and email subject' do
        expect(email.process_subject(variables)).to include('your BRG')
      end
    end

    describe '#process_variables' do
      it 'process variables correctly' do
        hash = email.process(email.content, variables)
        email_variables = [email_variable1, email_variable2]

        expect(email.process_variables(email_variables, hash)).to eq('user.name': "#{user.name.pluralize.upcase}")
      end
    end

    describe '#process_example' do
      it 'returns empty string if text is nil' do
        expect(email.process_example(nil)).to eq('')
      end

      it 'returns processed text' do
        expect(email.process_example('user.name')).to eq 'user.name'
      end
    end
  end
end
