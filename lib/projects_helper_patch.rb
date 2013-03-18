module ProjectsHelperPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      alias_method_chain :project_settings_tabs, :template
    end
  end

  module InstanceMethods
    def project_settings_tabs_with_template
      tabs = project_settings_tabs_without_template
      tabs << {
        :name => 'wiki_templates',
        :action => :view_templates,
        :partial => 'projects/settings/templates',
        :label => :label_template
      } if @project.module_enabled?(:wiki_templates) and User.current.allowed_to?(:view_templates, @project)
      tabs
    end
  end
end
