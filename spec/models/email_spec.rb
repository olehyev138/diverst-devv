require 'rails_helper'

RSpec.describe Email do
  it { expect(subject).to respond_to(:name) }
  it { expect(subject).to respond_to(:slug) }
  it { expect(subject).to respond_to(:use_custom_templates) }
  it { expect(subject).to respond_to(:custom_html_template) }
  it { expect(subject).to respond_to(:custom_txt_template) }
  
  describe "#destroy_callbacks" do
    it "removes the child objects" do
        email = create(:email)
        email_variable = create(:email_variable, :email => email)
        
        email.destroy
        
        expect{Email.find(email.id)}.to raise_error(ActiveRecord::RecordNotFound)
        expect{EmailVariable.find(email_variable.id)}.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end
