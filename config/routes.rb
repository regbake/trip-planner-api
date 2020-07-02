Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace 'v1' do
    get 'index', to: 'trip_planner#index'
    get 'capital_by_country', to: 'trip_planner#capital_by_country'
    get 'capital_by_square', to: 'trip_planner#capital_by_square'
  end
end
