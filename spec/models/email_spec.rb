require 'rails_helper'

RSpec.describe Email do
  it { expect(subject).to respond_to(:name) }
  it { expect(subject).to respond_to(:slug) }
  it { expect(subject).to respond_to(:use_custom_templates) }
  it { expect(subject).to respond_to(:custom_html_template) }
  it { expect(subject).to respond_to(:custom_txt_template) }

  it { expect(subject).to belong_to :enterprise }
  it { expect(subject).to have_many(:variables).class_name('EmailVariable') }
  it { expect(subject).to validate_presence_of(:name) }
  it { expect(subject).to validate_presence_of(:subject) }
end
