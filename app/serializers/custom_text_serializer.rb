class CustomTextSerializer < ApplicationRecordSerializer
  attributes :id, :erg, :program, :structure, :outcome, :badge, :segment, :dci_full_title,
             :dci_abbreviation, :member_preference, :parent, :sub_erg, :privacy_statement, :plural

  def text_hash
    @text_hash ||= begin
                     temp = object.attributes.dup
                     temp.delete('id')
                     temp.delete('enterprise_id')
                     temp
                   end
  end

  def plural
    Hash[text_hash.map { |key, value| [key, value.pluralize] }]
  end
end
