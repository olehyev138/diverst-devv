class NewsTagsController < ApplicationController
  def tags_search
    input = params['input']
    @tags = NewsTag.all
    @tags.append(NewsTag.new name: input) unless input.nil? || NewsTag.any? { |t| t.name == input }
    respond_to do |format|
      format.json do
        NewsTagsDatatable.new(view_context, @tags)
      end
    end
  end
end
