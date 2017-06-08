Rails.application.routes.draw do
  get 'search/index'
  get 'reports/researchers', 'reports#researchers'

  root 'search#index'


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
