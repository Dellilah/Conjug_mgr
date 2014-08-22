class PgroupsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_pgroup, only: [:show, :edit, :update, :destroy]
  before_action :is_owner, only: [:show, :edit, :update, :destroy]



  def index
    
  end

  def show
    @groupes = ['1','2','3']     
    if params[:groupes]
      @groupes = params[:groupes]
      @verbs = @pgroup.verbs.find(:all, :conditions =>["`group` IN (?)", @groupes]).group_by{|u| u.infinitive[0]}
    else
      @verbs = @pgroup.verbs.group_by{|u| u.infinitive[0]}
    end
  end

  def new
    @pgroup = Pgroup.new
  end

  def edit
    @groupes = Array.new()
    @verbs = Array.new()
    @excluded_verbs = Array.new()
    for i in 1..3
      v = @pgroup.verbs.where(:group => i)
      gr = Verb.where(:group => i)
      if v.length == gr.length
        @groupes.push(i.to_s)
      elsif gr.length - v.length < 10
        @groupes.push(i.to_s)
        @excluded_verbs = @excluded_verbs + (gr - v)
      else
        @verbs = @verbs + v
      end
    end
    if @verbs.length
      @verbs.map! { |e| e.infinitive }
      @verbs = @verbs.join(", ")

    else
      @verbs = ""
    end
    if @excluded_verbs.length
      @excluded_verbs.map! { |e| e.infinitive }
      @excluded_verbs = @excluded_verbs.join(", ")
    else
      @excluded_verbs = ""
    end
    puts @verbs
    puts @excluded_verbs
  end

  def update
    @gr_to_pr = params[:groupes]
    @excl_to_pr = params[:exluded_verbs].length > 0 ? params[:exluded_verbs].split(', ') : ''
    @add_to_pr = params[:verbs].length > 0 ? params[:verbs].split(', ') : ''

    #which verbs
    @verbs =  Verb.find(:all, :conditions =>
      ["(`group` IN (?) AND `infinitive` NOT IN (?)) OR `infinitive` IN (?) ",
      @gr_to_pr, @excl_to_pr, @add_to_pr ])

    respond_to do |format|
      if @pgroup.update(:name => params[:name], :verbs => @verbs)
        format.html { redirect_to @pgroup, notice: 'Group was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pgroup.errors, status: :unprocessable_entity }
      end
    end
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

    respond_to do |format|
      if @pgroup.save
        format.html { redirect_to @pgroup, notice: 'Group was successfully created.' }
        format.json { render action: 'show', status: :created, location: @pgroup }
      else
        format.html { render action: 'new' }
        format.json { render json: @pgroup.errors, status: :unprocessable_entity }
      end
    end

  end

  def destroy
    @pgroup = Pgroup.find(params[:id])
    @pgroup.destroy
    respond_to do |format|
      format.html { redirect_to pgroups_index_url }
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pgroup
      @pgroup = Pgroup.find(params[:id])
    end

    def is_owner
      unless current_user && current_user.id == @pgroup.user.id
        flash[:notice] = "You are not the owner of this group"
        redirect_to root_path
      end   
    end
end
