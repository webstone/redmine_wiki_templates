module WikiTemplatesProjectsHelperPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      alias_method_chain :project_settings_tabs, :wiki_templates
    end
  end

  module InstanceMethods
    def project_settings_tabs_with_wiki_templates
      tabs = project_settings_tabs_without_wiki_templates
      tabs << {
        :name => 'wiki_templates',
        :partial => 'wiki_templates/index',
        :label => :label_template
      } if @project.module_enabled?(:wiki_templates) and User.current.allowed_to?(:manage_wiki_templates, @project)
      tabs
    end
  end
end
