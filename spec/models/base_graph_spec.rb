require 'rails_helper'

RSpec.describe BaseGraph do
  # TODO figure out what directory this goes in

  let(:dummy_class) { Class.new { include BaseGraph } }

  describe 'Nvd3Formatter' do
  end

  describe 'ElasticsearchParser' do
  end

  describe 'GraphBuilder' do
  end

end
