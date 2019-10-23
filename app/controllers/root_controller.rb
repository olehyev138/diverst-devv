class RootController < ApplicationController
  def root
    redirect_to default_path
  end
end
