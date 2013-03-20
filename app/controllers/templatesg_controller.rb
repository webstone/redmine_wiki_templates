class TemplatesgController < ApplicationController
  unloadable
  model_object WikiTemplatesg
  layout 'admin'

  before_filter :require_admin
  before_filter :find_wiki_template, :only => [:edit, :destroy]

  def index
    @templates = WikiTemplatesg.find(:all)
    render :action => "index", :layout => false if request.xhr?
  end

  def new
    if request.post?
      @mitemplate = WikiTemplatesg.new
      @mitemplate.text = params[:mitemplate][:text]
      @mitemplate.name = params[:mitemplate][:name]
      @mitemplate.author = User.current
      @mitemplate.save
      redirect_to :controller => 'templatesg', :action => 'index'
    end
  end

  def destroy
    if @mitemplate.destroy
      flash[:notice] = l(:notice_successful_delete)
    end
    redirect_to :controller => 'templatesg', :action => 'index'
  end

  def edit
    if request.post?
      @mitemplate.text = params[:mitemplate][:text]
      @mitemplate.name = params[:mitemplate][:name]
      if @mitemplate.save
        flash[:notice] = l(:notice_successful_update)
      end
      redirect_to :controller => 'templatesg', :action => 'index'
    end
  end

  private

  def find_wiki_template
    begin
      @mitemplate = WikiTemplatesg.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_404
    end
  end
end
