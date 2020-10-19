require 'base64'
require 'rqrcode'

module Initiative::Actions
  def self.included(klass)
    klass.extend ClassMethods
  end

  def finalize_expenses(diverst_request)
    raise BadRequestException.new "#{self.class.name.titleize} ID required" if id.blank?

    unless self.finish_expenses!
      raise InvalidInputException.new({ message: errors.full_messages.first, attribute: errors.messages.first.first })
    end

    self
  end

  module ClassMethods
    def valid_scopes
      [
          'upcoming',
          'ongoing',
          'past',
          'not_archived',
          'archived',
          'of_annual_budget',
          'joined_events_for_user',
          'available_events_for_user',
          'for_groups',
          'for_segments',
          'date_range',
      ]
    end

    def base_preloads(diverst_request) ##
      case diverst_request.action
      when 'index' then [:initiative_users, :owner, :group, :picture_attachment, group: :user_groups]
      when 'show' then
        preloads = [
            :pillar,
            :owner,
            :outcome,
            :group,
            :participating_groups,
            :qr_code_attachment,
            :initiative_users,
        ]
        preloads.append(:budget_item, :budget, :expenses) if diverst_request.options[:with_budget]
        preloads.append(:comments) if diverst_request.options[:with_comments]
        # preloads.append(:initiative_users) if diverst_request.policy.attendees?
        preloads
      else []
      end
    end

    def generate_qr_code(diverst_request, params)
      item = show(diverst_request, params)
      hash = {
        id: item.id,
        name: item.name
      }
      enc = Base64.encode64(hash.to_json)
      png = RQRCode::QRCode.new(enc).as_png
      item.qr_code.attach(io: StringIO.new(png.to_s), filename: "#{item.name}_qr_code")
      item.save!
      item
    end
  end
end
