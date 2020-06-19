class FixCustomText < ActiveRecord::Migration[5.2]
  def change
    #
    ## Fix Custom Text data
    #  - Set empty strings to custom text defaults (defined in schema.rb)
    #  - Add a not_null constraint to all columns
    #

    custom_text_strings = {
        erg: 'Group',
        program: 'Goal',
        structure: 'Structure',
        outcome: 'Focus Areas',
        badge: 'Badge',
        segment: 'Segment',
        dci_full_title: 'Engagement',
        dci_abbreviation: 'Engagement',
        member_preference: 'Member Survey',
        parent: 'Parent',
        sub_erg: 'Sub-Group',
        privacy_statement: 'Privacy Statement'
    }

    # Set custom text attribute to default if blank
    CustomText.all.each do |ct|
      custom_text_strings.each do |ct_str, ct_str_default|
        if ct.send(ct_str).blank?
          ct.send("#{ct_str}=", ct_str_default)
          ct.save!(validate: false)
        end
      end
    end

    # Add not_null constraint to custom_text column
    # Do it here so as we dont do it over again if there are more then one enterprise
    custom_text_strings.keys.each do |ct_str|
      change_column_null :custom_texts, ct_str, false
    end
  end
end
