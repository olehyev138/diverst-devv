require 'rails_helper'

RSpec.describe EmailVariable do
  it { expect(subject).to belong_to(:enterprise_email_variable) }
  it { expect(subject).to belong_to(:email) }

  it { expect(subject).to validate_presence_of(:email) }
  it { expect(subject).to validate_presence_of(:enterprise_email_variable) }

  describe '#format' do
    it 'returns empty string when value is not string' do
      expect(subject.format(1)).to eq('')
    end

    it 'returns pluralized string' do
      subject.pluralize = true
      expect(subject.format('email')).to eq('emails')
    end

    it 'returns downcased string' do
      subject.downcase = true
      expect(subject.format('EMAIL')).to eq('email')
    end

    it 'returns titleized string' do
      subject.titleize = true
      expect(subject.format('email')).to eq('Email')
    end

    it 'returns upcased string' do
      subject.upcase = true
      expect(subject.format('email')).to eq('EMAIL')
    end
  end
end
