Rails.application.routes.draw do
  match 'projects/:project_id/wiki_templates/new', :to => 'wiki_templates#new', :via => [:get, :post]
  match 'wiki_templates/preview', :to => 'wiki_templates#preview'
  match 'wiki_templates/load', :to => 'wiki_templates#load'
  resources :wiki_templates, :except => ['index', 'new', 'create']
end
