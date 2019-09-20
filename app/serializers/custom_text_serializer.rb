class CustomTextSerializer < ApplicationRecordSerializer
  attributes :id, :erg, :program, :structure, :outcome, :badge, :segment, :dci_full_title,
             :dci_abbreviation, :member_preference, :parent, :sub_erg, :privacy_statement

end
