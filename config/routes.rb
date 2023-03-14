Rails.application.routes.draw do

  concern :marc_viewable, Blacklight::Marc::Routes::MarcViewable.new
  concern :searchable, Blacklight::Routes::Searchable.new

  resource :catalog, only: [:index], as: 'catalog', path: '/catalog', controller: 'catalog' do
    concerns :searchable
  end
  devise_for :users
  concern :exportable, Blacklight::Routes::Exportable.new

  resources :solr_documents, only: [:show], path: '/catalog', controller: 'catalog' do
    concerns [:exportable, :marc_viewable]
  end

  resources :bookmarks do
    concerns :exportable

    collection do
      delete 'clear'
    end
  end
  mount Blacklight::Engine => '/'
  root to: "catalog#index"
  resources :resources

#  get '/resources/random_output', to: 'resources#random_output'

  get 'random_output', action: :random_output, controller: 'resources'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
