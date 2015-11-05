class NewsLinksController < ApplicationController
  # Gets basic information about a web article (title and lede) from its url
  def url_info
    # page = Pismo::Document.new(params[:url])
    # Removed since pismo doesnt work wirh JRuby

    render json: {
      title: "",
      description: ""
    }
  end
end
