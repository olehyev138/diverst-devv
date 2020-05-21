class Tag < BaseClass
  belongs_to :resource

  validates_length_of :name, maximum: 191
  validates :name, presence: true

  def self.ids_from_tokens(list)
    list.collect do |token|
      next if token.blank?

      if token.to_i > 0
        token.to_i
      else
        tag = Tag.new(name: token)
        tag.save!
        tag.id
      end
    end
  end
end
