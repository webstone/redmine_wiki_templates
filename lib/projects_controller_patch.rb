module ProjectsControllerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      alias_method_chain :settings, :template
    end
  end

  module InstanceMethods
    def settings_with_template
      settings_without_template
      @templates = WikiTemplates.find_all_by_project_id(@project.id)
    end
  end
end
