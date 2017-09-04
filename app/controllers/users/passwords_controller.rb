class Users::PasswordsController < Devise::PasswordsController

    # This was overwritten to behave the same way for correct and incorrect emails
    # to prevent brute force username lookup
    # POST /resource/password

    def create
        self.resource = resource_class.send_reset_password_instructions(resource_params)
        yield resource if block_given?

        flash[:notice] = "You will shortly receive password reset instructions to email"
        respond_with({}, location: after_sending_reset_password_instructions_path_for(resource_name))
    end
end
