class WikiTemplatesApplicationHooks < Redmine::Hook::ViewListener
  render_on :view_layouts_base_body_bottom, :partial => 'wiki_templates/body_bottom'
end

