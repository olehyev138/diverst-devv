require 'rails_helper'

RSpec.describe Email do
  it { expect(subject).to belong_to :enterprise }
  it { expect(subject).to have_many(:email_variables).class_name('EmailVariable') }
  it { expect(subject).to have_many(:variables).class_name('EnterpriseEmailVariable') }
  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:subject) }

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
end
