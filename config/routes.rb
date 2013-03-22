Rails.application.routes.draw do
  match 'wiki_templates/new', :to => 'wiki_templates#new', :via => [:get, :post]
  match 'wiki_templates/:id/edit', :to => 'wiki_templates#edit', :via => :get
  match 'wiki_templates/:id/:action', :to => 'wiki_templates', :via => :post
end
