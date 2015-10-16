class NewsLinksController < ApplicationController
  # Gets basic information about a web article (title and lede) from its url
  def url_info
    page = Pismo::Document.new(params[:url])

    render json: {
      title: page.title,
      description: page.lede
    }
  end
end
