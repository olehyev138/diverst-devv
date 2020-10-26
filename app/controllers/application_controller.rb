class ApplicationController < ActionController::API
  include ActionView::Helpers::TranslationHelper # Allows us to use the `t` translation helper method in controllers
end
