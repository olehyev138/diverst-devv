module Optionnable
  extend ActiveSupport::Concern

  included do
    after_initialize :set_options_array
    attr_accessor :options
  end

  protected

  def set_options_array
    return self.options = [] if self.options_text.nil?
    self.options = self.options_text.lines.map(&:chomp)
  end
end