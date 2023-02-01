class Resource < ApplicationRecord
  validates :url, presence: true 
  
  after_commit :index_data_in_solr, on: [:create, :update]
  before_destroy :remove_data_from_solr

#  after_save :index_record
#  before_destroy :remove_from_index

  #  attr_accessible :title_index
  attr_accessor :title_index

  # sunspot solr
  searchable do
      text :title, :description, :url
  end


  def to_solr
    {
      "title" => title, "description" => description, "url" => url
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




#  attr_accessible :title_index
#  attr_accessor :title_index

#  def to_solr
#    # *_texts here is a dynamic field type specified in solrconfig.xml
#    {'id' => id,
#     'title_texts' => title_index}
#  end

#  def index_record
#    SolrService.add(self.to_solr)
#    SolrService.commit
#    Blacklight::SolrService.add(self.to_solr)
#    Blacklight::SolrService.commit
#  end

#  def remove_from_index
#    SolrService.delete_by_id(self.id)
#    SolrService.commit
#    Blacklight::SolrService.delete_by_id(self.id)
#    Blacklight::SolrService.commit
#  end

end
