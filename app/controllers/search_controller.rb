class SearchController < ApplicationController
  def index
    q = params[:q]
    @q = q
    
    unless q.blank?
      @res = Resource.search do
        fulltext q
      end
    end
  end
end
