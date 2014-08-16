class PgroupsController < ApplicationController
  before_filter :authenticate_user!

  def index
    
  end

  def show
    @groupes = ['1','2','3']     
    @group =  Pgroup.find(params[:id])
    if params[:groupes]
      @groupes = params[:groupes]
      @verbs = @group.verbs.find(:all, :conditions =>["`group` IN (?)", @groupes]).group_by{|u| u.infinitive[0]}
    else
      @verbs = @group.verbs.group_by{|u| u.infinitive[0]}
    end
  end

  def new
    @pgroup = Pgroup.new
  end

  def edit
    @pgroup = Pgroup.find(params[:id].to_i)
  end

  def create
    @pgroup = Pgroup.new(:name => params[:name], :user_id => current_user.id)
    @gr_to_pr = params[:groupes]
    @excl_to_pr = params[:exluded_verbs].length > 0 ? params[:exluded_verbs].split(', ') : ''
    @add_to_pr = params[:verbs].length > 0 ? params[:verbs].split(', ') : ''

    #which verbs
    @verbs =  Verb.find(:all, :conditions =>
      ["(`group` IN (?) AND `infinitive` NOT IN (?)) OR `infinitive` IN (?) ",
      @gr_to_pr, @excl_to_pr, @add_to_pr ])

    @pgroup.verbs = @verbs
    @pgroup.save

  end

  def update
  end

  def destroy
    @pgroup = Pgroup.find(params[:id])
    @pgroup.destroy
    respond_to do |format|
      format.html { redirect_to pgroups_index_url }
      format.json { head :no_content }
    end

  end
end
