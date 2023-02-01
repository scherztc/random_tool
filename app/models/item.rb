class Item < ActiveRecord::Base
  …
  after_commit :index_data_in_solr, on: [:create, :update]
  before_destroy :remove_data_from_solr
  …

  def to_solr
    {
      "title" => title, "description" => description, "price" => price, "category" => category_id.titleize,
      "brand" => brand_id.titleize, "condition" => condition.titleize, "format" => format.titleize,
      "screen_size" => screen_size, "color" => color.titleize, "memory" => memory, "id" => id
    }
  end

  def index_data_in_solr
    SolrService.add(to_solr)
    SolrService.commit
  end

  def remove_data_from_solr
    SolrService.delete_by_id(id)
    SolrService.commit
  end
end
