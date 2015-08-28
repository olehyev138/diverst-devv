module Optionnable
  extend ActiveSupport::Concern

  included do
    has_many :options, class_name: "FieldOption", foreign_key: "field_id", dependent: :destroy

    attr_accessor :options_text

    accepts_nested_attributes_for :options, :reject_if => :all_blank, :allow_destroy => true

    after_validation :parse_options_text
    after_initialize :set_options_text
  end

  protected

  def set_options_text
    return self.options_text = "" if self.options.nil?
    option_titles = self.options.map(&:title)
    self.options_text = option_titles.join("\r\n")
  end

  def parse_options_text
    return if self.options_text.blank? || self.options_text.nil?

    self.options = self.options_text.split("\r\n").map do |option_title|
      FieldOption.new(title: option_title, field_id: self.id)
    end
  end
end