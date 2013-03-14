Rails.application.routes.draw do
  match 'templatesg', :to => 'templatesg#index', :via => :get
  match 'templatesg/new', :to => 'templatesg#new', :via => [:get, :post]
  match 'templatesg/:id/edit', :to => 'templatesg#edit', :via => :get
  match 'templatesg/:id/:action', :to => 'templatesg', :via => :post
  match 'templates/new', :to => 'templates#new', :via => [:get, :post]
  match 'templates/:id/edit', :to => 'templates#edit', :via => :get
  match 'templates/:id/:action', :to => 'templates', :via => :post
end
