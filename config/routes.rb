Rails.application.routes.draw do
  root to: 'pages#main'
  get 'edit/:id' => 'pages#main'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
