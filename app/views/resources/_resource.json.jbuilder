json.extract! resource, :id, :title, :description, :url, :created_at, :updated_at, :category
json.url resource_url(resource, format: :json)
