require 'rails_helper'
RSpec.shared_examples "redirect user to users/sign_in path" do
	it "redirect user to users/sign_in path", skip: "pending for now due to inconsistent results" do
		expect(response).to redirect_to new_user_session_path
	end
end