class Email < BaseClass
  include PublicActivity::Common

  CUSTOM_MAILER_METHOD_NAME = 'custom'
  CUSTOM_MAILER_MAILER_NAME = 'custom_email_mailer'

  # associations
  belongs_to :enterprise

  attr_accessor :receivers

  has_many :variables, class_name: 'EmailVariable', dependent: :destroy

  before_validation :assign_mailer_for_custom_email, if: :custom?

  # validations
  validates_length_of :description, maximum: 191
  validates_length_of :template, maximum: 191
  validates_length_of :mailer_method, maximum: 191
  validates_length_of :mailer_name, maximum: 191
  validates_length_of :content, maximum: 65535
  validates_length_of :subject, maximum: 191
  validates_length_of :name, maximum: 191
  validates :name, :subject, :content, :description, :mailer_name, :mailer_method, presence: true

  def process(text, objects)
    # get all the interpolated strings
    strings = text.scan(/{([^}]*)}/).flatten

    hash = {}

    strings.each do |string|
      keys = string.split('.')
      object = objects[keys.first.to_sym]
      value = object if keys.second.nil?
      value = object.send(keys.second) if keys.second
      next if value.nil?

      hash.merge!({ "#{string}": value })
    end
    hash
  end

  def process_content(objects)
    hash = process(content, objects)
    hash = process_variables(variables, hash)
    content % hash
  end

  def process_subject(objects)
    hash = process(subject, objects)
    hash = process_variables(variables, hash)
    subject % hash
  end

  def process_variables(email_variables, hash)
    email_variables.each do |variable|
      next if hash[variable.enterprise_email_variable[:key].to_sym].nil?

      hash[variable.enterprise_email_variable[:key].to_sym] = variable.format(hash[variable.enterprise_email_variable[:key].to_sym])
    end
    hash
  end

  def process_example(text)
    return '' if text.nil?

    replace = {}
    # get the strings
    strings = text.scan(/{([^}]*)}/).flatten

    #
    strings.each do |string|
      variable = variables.joins(:enterprise_email_variable).find_by(enterprise_email_variables: { key: string })
      next if variable.nil?

      replace.merge!({ "#{string}": variable.enterprise_email_variable.example })
    end

    text % replace
  end

  protected

  def assign_mailer_for_custom_email
    return unless self.custom?

    self.mailer_name = Email::CUSTOM_MAILER_MAILER_NAME
    self.mailer_method = Email::CUSTOM_MAILER_METHOD_NAME
  end
end
