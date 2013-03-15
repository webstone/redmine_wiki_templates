module WikiControllerPatch
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.class_eval do
      unloadable
      alias_method_chain :edit, :template
      alias_method_chain :show, :template
      alias_method_chain :preview, :template
    end
  end

  module InstanceMethods
    # edit an existing page or a new one
    def edit_with_template
      return render_403 unless editable?

      select_elige_plantilla = '0'
      if params[:issue_plantilla]
        select_elige_plantilla = params[:issue_plantilla]
      end

      # If the user select a template he could create a page with it
      if @page.new_record?
        @page.content = WikiContent.new(:page => @page)
        if params[:parent].present?
          @page.parent = @page.wiki.find_page(params[:parent].to_s)
        end
      end

      @content = @page.content_for_version(params[:version])

      case (select_elige_plantilla)
      when '0'
        @content.text = initial_page_content(@page) if @content.text.blank?
      else
        if select_elige_plantilla.to_s.index('*')
          id_template_chosen = select_elige_plantilla[0,select_elige_plantilla.length-1]
          miwiki = WikiTemplatesg.find(id_template_chosen)
        else
          miwiki = WikiTemplates.find(select_elige_plantilla)
        end
        @content.text = miwiki.text
      end

      # don't keep previous comment
      @content.comments = nil

      # To prevent StaleObjectError exception when reverting to a previous version
      @content.version = @page.content.version

      @text = @content.text
      if params[:section].present? && Redmine::WikiFormatting.supports_section_edit?
        @section = params[:section].to_i
        @text, @section_hash = Redmine::WikiFormatting.formatter.new(@text).get_section(@section)
        render_404 if @text.blank?
      end
      render :action => 'my_edit'
    end

    # display a page (in editing mode if it doesn't exist)
    def show_with_template
      if @page.new_record?
        if @project.module_enabled?('templates')
          if User.current.allowed_to?(:edit_wiki_pages, @project) && editable?
            @templates = WikiTemplates.find_all_by_project_id(@project.id)
            @templatesg = WikiTemplatesg.find(:all)
            allowed_parents = @project.allowed_parents.compact
            listprojects_id = allowed_parents.map{|p| p.id} if allowed_parents
            @templatesf = WikiTemplates.where(:project_id => listprojects_id, :visible_children => true)
            render :action => 'eligeplantilla'
          else
            render_404
          end
        else
          if User.current.allowed_to?(:edit_wiki_pages, @project) && editable?
            #edit
            render :action => 'my_edit'
          else
            render_404
          end
          return
        end
        return
      end
      show_without_template
    end

    def preview_with_template
      # If the user choose a template he will see the preview of it
      if params[:issue_plantilla]
        select_elige_plantilla = params[:issue_plantilla]
        if select_elige_plantilla!='0'
          if select_elige_plantilla.to_s.index('*')
            id_template_chosen = select_elige_plantilla[0,select_elige_plantilla.length-1]
            ptemplate = WikiTemplatesg.find(id_template_chosen)
            @text = ptemplate.text
          else
            ptemplate = WikiTemplates.find(select_elige_plantilla)
            @text = ptemplate.text
          end
        else
          @text = ''
        end
      # If the user doesn't choose a template he will see the preview of a page
      else
        page = @wiki.find_page(params[:id])
        # page is nil when previewing a new page
        return render_403 unless page.nil? || editable?(page)
        if page
          @attachements = page.attachments
          @previewed = page.content
        end
        @text = params[:content][:text]
      end
      render :partial => 'common/preview'
    end
  end
end
