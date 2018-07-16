require 'rails_helper'

RSpec.describe FrequencyPeriod, type: :model do
    
    describe "validations" do
        let(:frequency_period){ build_stubbed(:frequency_period) }
        it { expect(frequency_period).to validate_inclusion_of(:name).in_array(["second", "minute", "hour", "day", "week", "month"]) }
    end
end
