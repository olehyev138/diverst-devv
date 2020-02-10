require 'rails_helper'

RSpec.describe PreventMailInterceptor, 'delivery interception' do
  xit 'prevents mailing some recipients' do
    allow(PreventMailInterceptor).to receive(:deliver?).and_return false
    expect {
      deliver_mail
    }.to change { ActionMailer::Base.deliveries.count }.by(0)
  end

  it 'allows mailing other recipients' do
    allow(PreventMailInterceptor).to receive(:deliver?).and_return true
    expect {
      deliver_mail
    }.to change { ActionMailer::Base.deliveries.count }.by(1)
  end

  def deliver_mail
    ActionMailer::Base.mail(to: 'a@foo.com', from: 'b@foo.com', body: 'test').deliver_now
  end
end

RSpec.describe PreventMailInterceptor, '.deliver?' do
  it 'is false for recipients like abcedf@enterprise3.com' do
    message = double(to: %w[abcdef@enterprise3.com])
    expect(
      PreventMailInterceptor.deliver?(message)
    ).to eq false
  end

  it 'is true for other recipients' do
    message = double(to: %w[user@gmail.com])
    expect(
      PreventMailInterceptor.deliver?(message)
    ).to eq true
  end
end
