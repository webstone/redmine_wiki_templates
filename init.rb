require 'redmine'

Rails.configuration.to_prepare do
  # use require_dependency if you plan to utilize development mode
  require_dependency 'wiki_controller'
  WikiController.send(:include, WikiControllerPatch)
  require_dependency 'projects_helper'
  ProjectsHelper.send(:include, ProjectsHelperPatch)
end

Redmine::Plugin.register :redmine_wiki_templates do
  name 'Redmine Wiki Templates plugin'
  author 'Marta Gonzalez de Chaves Aguilera, Daigo UCHIYAMA'
  description 'This plugin allow you choose a wiki template when you add a new wiki page.'
  version '0.2.0'
  url 'https://github.com/ucho/redmine_wiki_templates'
  requires_redmine :version_or_higher => '2.2.0'
  project_module :templates do
    permission :view_templates, :templates => :find_project
    permission :create_templates, :templates => [:new, :find_project]
    permission :delete_templates, :templates => [:destroy, :find_project]
    permission :edit_templates, :templates => [:edit, :find_project]
  end
  menu :admin_menu, :templatesg, { :controller => 'templatesg', :action => 'index' }, :caption => :app_menu_global_templates
end

class RedmineToolbarHookListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context)
    stylesheet_link_tag('gsc_plantillas', :plugin => :redmine_wiki_templates)
  end
end
