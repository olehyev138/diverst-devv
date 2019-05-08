module FeatureSpecRefactors
  module CustomHelpers
    def pause_test_and_browse_site_in_test_mode
      if Rails.env.test?
        puts current_url
        require 'pry-rails'; binding.pry
      end
    end

    def segment_members_of_group(segment, group)
      segment.members.includes(:groups).select do |user|
        user.groups.include? group
      end
    end

    def c_t(type)
      @custom_text ||= current_user.enterprise.custom_text rescue CustomText.new
      @custom_text.send("#{type}_text")
    end

    def logout_user_in_session
      visit user_root_path

      click_link 'Log out', match: :first
    end

    def format_date_time(date_time)
      date_time.strftime('%Y-%m-%d %H:%m')
    end

    def set_custom_text_fields
      create(:field, title: 'BIO', enterprise_id: enterprise.id)
    end

    def set_custom_select_fields
      create(:select_field, title: 'Gender', options_text: "Male \r\nFemale", enterprise_id: enterprise.id)
    end

    def set_custom_checkbox_fields
      create(:checkbox_field, title: 'Programming Language', options_text: "Ruby\r\nElixir\r\nC++\r\nJavaScript",
                              enterprise_id: enterprise.id)
    end

    def set_custom_numeric_fields
      create(:numeric_field, title: 'Age-restrictions', min: 18, max: 98, enterprise_id: enterprise.id)
    end

    def set_custom_date_fields
      create(:date_field, title: 'Date of Birth', enterprise_id: enterprise.id)
    end

    def computed_style(selector, prop)
      string = page.evaluate_script(
        "window.getComputedStyle(document.querySelector('#{selector}')).#{prop}"
      )
      phrase = string[18..-1]
      string.slice! phrase
      string
    end
  end

  module CustomMatchers
    def default_primary_color
      'rgb(123, 119, 201)'
    end

    def have_default_primary_color
      eq default_primary_color
    end

    def have_custom_color(color)
      eq color
    end

    [:custom_logo, :banner, :sponsor_image, :icon_image].each do |suffix|
      define_method :"have_#{suffix}" do |image|
        have_css("img[src*=#{image}]")
      end
    end

    def have_default_logo
      have_css('img[src*="logo.png"]')
    end

    def have_no_default_logo
      have_no_css('img[src*="/\Alogo.png\z/"]')
    end

    def have_no_banner
      have_no_css('.enterprise-banner')
    end

    def have_sponsor_video(video)
      have_css("video[src*=#{video}]")
    end

    def display_timezone(timezone)
      have_content timezone
    end

    def disable_home_sponsor_message_button
      page.find_field('enterprise[disable_sponsor_message]')
    end

    def have_flash_message(message)
      have_content message
    end
  end

  module FormHelpers
    def user_logs_in_with_correct_credentials(user)
      visit root_path

      fill_in 'user_email', with: user.email
      fill_in 'user_password', with: user.password
      click_on 'Log in'

      expect(page).to have_current_path user_root_path
    end

    def user_logs_in_with_incorrect_credentials
      visit root_path

      fill_in 'user_email', with: 'idontexist@diverst.com'
      fill_in 'user_password', with: 'wh4t3v3r'
      click_on 'Log in'

      expect(page).to have_current_path new_user_session_path
    end

    def expect_new_text_field_form
      within('.nested-fields') do
        expect(page).to have_field '* Title', with: 'New text field'
        expect(page).to have_unchecked_field('Allow multiple lines')
        expect(page).to have_unchecked_field('Hide from users')
        expect(page).to have_unchecked_field('Allow user to edit')
        expect(page).to have_unchecked_field('Set as mandatory')
        expect(page).to have_field('Saml attribute', with: '')
      end
    end

    def expect_new_select_field_form
      within('.nested-fields') do
        expect(page).to have_field('* Title', with: 'New select field', type: 'text')
        expect(page).to have_field('Options (one per line)', type: 'textarea')
        expect(page).to have_unchecked_field('Hide from users', type: 'checkbox')
        expect(page).to have_unchecked_field('Allow user to edit', type: 'checkbox')
        expect(page).to have_unchecked_field('Set as mandatory', type: 'checkbox')
        expect(page).to have_field('Saml attribute', with: '')
      end
    end

    def expect_new_checkbox_field_form
      within('.nested-fields') do
        expect(page).to have_field('* Title', with: 'New checkbox field', type: 'text')
        expect(page).to have_field('Options (one per line)', type: 'textarea')
        expect(page).to have_unchecked_field('Use multi-select field', type: 'checkbox')
        expect(page).to have_unchecked_field('Hide from users', type: 'checkbox')
        expect(page).to have_unchecked_field('Allow user to edit', type: 'checkbox')
        expect(page).to have_unchecked_field('Set as mandatory', type: 'checkbox')
        expect(page).to have_field('Saml attribute', with: '')
      end
    end

    def expect_new_numeric_field_form
      within('.nested-fields') do
        expect(page).to have_field('* Title', with: 'New numeric field', type: 'text')
        expect(page).to have_field('Min', type: 'number')
        expect(page).to have_field('Max', type: 'number')
        expect(page).to have_unchecked_field('Show slider instead', type: 'checkbox')
        expect(page).to have_unchecked_field('Hide from users', type: 'checkbox')
        expect(page).to have_unchecked_field('Allow user to edit', type: 'checkbox')
        expect(page).to have_unchecked_field('Set as mandatory', type: 'checkbox')
        expect(page).to have_field('Saml attribute', with: '')
      end
    end

    def expect_new_date_field_form
      within('.nested-fields') do
        expect(page).to have_field('* Title', with: 'New date field', type: 'text')
        expect(page).to have_unchecked_field('Hide from users')
        expect(page).to have_unchecked_field('Allow user to edit')
        expect(page).to have_unchecked_field('Set as mandatory')
        expect(page).to have_field('Saml attribute', with: '')
      end
    end

    def fill_user_invitation_form(with_custom_fields:)
      fill_in 'user[email]', with: 'derek@diverst.com'
      fill_in 'user[first_name]', with: 'Derek'
      fill_in 'user[last_name]', with: 'Owusu-Frimpong'

      if with_custom_fields
        page.all('#all-custom-fields') do
          fill_in 'BIO', with: 'I am a passionate ruby developer'
          select 'Male', from: 'Gender'
        end
      end

      click_on 'Send an invitation'
    end
  end
end
