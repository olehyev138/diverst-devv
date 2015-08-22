class SelectField < Field
  has_many :options, class_name: "FieldOption", foreign_key: "field_id", dependent: :destroy
  accepts_nested_attributes_for :options, :reject_if => :all_blank, :allow_destroy => true

  def pretty_value(value)
    self.options.find{ |option| option.id == value.to_i }.title
  end

  # Get a match score based on two things:
  #   - Community size contrast (a small cluster with a large cluster will be worth more than 2 small clusters)
  #   - Community size (small clusters are worth more)
  def match_score_between(e1, e2)
    e1_value = e1.info[self.id]
    e2_value = e2.info[self.id]

    # Returns nil if we don't have all the employee info necessary to get a score
    return nil unless e1_value && e2_value

    e1_option = FieldOption.find(e1_value)
    e2_option = FieldOption.find(e2_value)

    e1_popularity = e1_option.popularity
    e2_popularity = e2_option.popularity

    pp(e1_popularity)
    pp(e2_popularity)

    popularity_total = e1_popularity + e2_popularity

    size_score = 1 - e1_popularity + e2_popularity
    contrast_score = (e1_popularity - e2_popularity).abs / popularity_total

    total_score = (size_score + contrast_score).to_f / 2
  end
end
