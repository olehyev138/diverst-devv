class CustomTextSerializer < ApplicationRecordSerializer
  attributes :id, :erg, :program, :structure, :outcome, :badge, :segment, :dci_full_title,
             :dci_abbreviation, :member_preference, :parent, :sub_erg, :privacy_statement, :region, :plural

  def text_hash
    @text_hash ||= object.attributes.except('id', 'enterprise_id')
  end

  def plural
    Hash[text_hash.map { |key, value| [key, value.pluralize] }]
  end
end
