class Auth::Callbacks::YammerController < ApplicationController
  def callback
    ap params
    head 200
  end
end
