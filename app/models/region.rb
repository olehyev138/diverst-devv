class Region < ApplicationRecord
  include ActionView::Helpers::TranslationHelper
  include PublicActivity::Common
  include Region::Actions

  belongs_to :parent, class_name: 'Group'
  has_many :children, class_name: 'Group', foreign_key: :region_id, dependent: :nullify

  validates :name, presence: true
  validates :parent, presence: true
  validates_length_of :name, maximum: 191
  validates_length_of :home_message, maximum: 65535
  validates_length_of :short_description, maximum: 65535
  validates_length_of :description, maximum: 65535

  validate :ensure_parent_isnt_a_child_group

  after_create :set_position

  scope :is_private,        -> { where(private: true) }
  scope :non_private,       -> { where(private: false) }

  def to_s
    name
  end

  def file_safe_name
    name.gsub(/[^0-9A-Za-z.\-]/, '_')
  end

  private

  def set_position
    self.position = self.id
  end

  def ensure_parent_isnt_a_child_group
    if parent.is_sub_group?
      errors.add(:parent, t('errors.region.parent_cant_be_child_group'))
    end
  end
end
