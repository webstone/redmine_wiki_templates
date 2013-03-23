Rails.application.routes.draw do
  match 'projects/:project_id/wiki_templates/new', :to => 'wiki_templates#new', :via => [:get, :post]
  resources :wiki_templates, :except => ['index', 'new', 'create']
end
