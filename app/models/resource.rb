class Resource < ApplicationRecord
  validates :url, presence: true 
end
