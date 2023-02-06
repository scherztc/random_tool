class SolrService
  @@connection = false

  def initialize(options = {})
      @options = { timeout: 120, open_timeout: 120, url: 'http://localhost:8983/solr' }.merge(options)
  end


  def self.connect
    @@connection = RSolr.connect(url: "http://localhost:8983/solr/blacklight-core")
    @@connection
  end

  def self.add(params)
    connect unless @@connection
    @@connection.add(params)
  end

  def self.commit
    connect unless @@connection
    @@connection.commit
  end

  def self.delete_by_id(id)
    connect unless @@connection
    @@connection.delete_by_id(id)
  end
end
