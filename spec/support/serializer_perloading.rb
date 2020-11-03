require 'rails_helper'

RSpec.shared_examples 'preloads serialized data' do |*factory_args, actions: ['index', 'show'], options: {}, pending: false|
  describe 'preloading data' do
    actions.each do |action|
      context "for action '#{action}'", pending: pending do
        let!(:object) { create(*factory_args) }
        let!(:tester) { described_class::Tester.new(object, action: action, options: options) }

        it {expect(tester.preloaded?).to be true}
      end
    end
  end
end
