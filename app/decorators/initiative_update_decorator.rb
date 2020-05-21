class InitiativeUpdateDecorator < Draper::Decorator
  # Outputs a well-formated span with the variance in %, colored to represent sign
  def variance_from_previous(field)
    variance = object.variance_from_previous(field)
    return nil if variance.nil?

    sign = variance > 0 ? '+' : '' # The - sign is alreadyadded by to_s when the variance is negative
    variance_string = (variance * 100).round(1).to_s
    span_class = variance > 0 ? 'positive' : 'error'

    helpers.content_tag :span, class: span_class do
      "(#{sign}#{variance_string}%)"
    end
  end
end
