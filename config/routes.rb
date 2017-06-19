Rails.application.routes.draw do
  get 'search/index'
  root 'search#index'
  get 'reports/index'

  resources :researchers, only: [:index, :show]
  get 'reports/publications_by_year'
  get 'reports/publications_by_country'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
