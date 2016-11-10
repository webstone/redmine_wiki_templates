Rails.application.routes.draw do
  get 'projects/:project_id/wiki_templates/new', :to => 'wiki_templates#new'
  post 'projects/:project_id/wiki_templates/new', :to => 'wiki_templates#new'
  match 'wiki_templates/preview', :to => 'wiki_templates#preview', :via => [:post, :patch]
  get 'wiki_templates/load', :to => 'wiki_templates#load'
  resources :wiki_templates, :except => ['index', 'new', 'create']
end
