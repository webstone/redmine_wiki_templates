require 'redmine'

Rails.configuration.to_prepare do
  # use require_dependency if you plan to utilize development mode
  require_dependency 'wiki_controller'
  WikiController.send(:include, WikiTemplatesWikiControllerPatch)
  require_dependency 'projects_helper'
  ProjectsHelper.send(:include, WikiTemplatesProjectsHelperPatch)
end

Redmine::Plugin.register :redmine_wiki_templates do
  name 'Redmine Wiki Templates plugin'
  author 'Marta Gonzalez de Chaves Aguilera, Daigo UCHIYAMA'
  description 'This plugin allow you choose a wiki template when you add a new wiki page.'
  version '0.2.0'
  url 'https://github.com/ucho/redmine_wiki_templates'
  requires_redmine :version_or_higher => '2.2.0'
  project_module :wiki_templates do
    permission :show_wiki_templates, {:wiki_templates => [:show]}
    permission :manage_wiki_templates, {:wiki_templates => [:new, :edit, :update, :destroy]}
  end
end

class RedmineToolbarHookListener < Redmine::Hook::ViewListener
  def view_layouts_base_html_head(context)
    stylesheet_link_tag('gsc_plantillas', :plugin => :redmine_wiki_templates)
  end
end
