class PgroupsController < ApplicationController
  before_filter :authenticate_user!
  before_action :transl_count
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
      v = @pgroup.verbs.where(:group => i, :id => 0..92)
      gr = Verb.where(:group => i, :id => 0..92)
      if v.length == gr.length
        @groupes.push(i.to_s)
      else
        if (i == 3 and gr.length - v.length < 10) or (i == 2 and gr.length - v.length < 4) or ( i==1 and gr.length - v.length < 9)
          @groupes.push(i.to_s)
          @excluded_verbs = @excluded_verbs + (gr - v)
        else
          @verbs = @verbs + v
        end
      end
    end
    @verbs = @verbs + @pgroup.verbs.where(:id => 93..1900) 
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
  end

  def update
    @gr_to_pr = params[:groupes]
    @excl_to_pr = params[:exluded_verbs].length > 0 ? params[:exluded_verbs].split(', ') : ''
    @add_to_pr = params[:verbs].length > 0 ? params[:verbs].split(', ') : ''

    #which verbs
    if @add_to_pr != ''
      check_if_in_db(@add_to_pr)
    end
    @verbs =  Verb.find(:all, :conditions =>
      ["(`group` IN (?) AND `infinitive` NOT IN (?) AND `id` IN (?)) OR `infinitive` IN (?) ",
      @gr_to_pr, @excl_to_pr, (0..94), @add_to_pr ])

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
      
    if @add_to_pr != ''
      check_if_in_db(@add_to_pr)
    end

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

  def check_if_in_db(collection)
    not_in_db = Array.new()
    
    #which verbs
    collection.each do |v|
      if Verb.where(:infinitive => v).count == 0
        # we have to group all the verbs that should be added to DB
        # it's better than adding it immediatly cause we will have to run through 196 json files once
        not_in_db.push(v)
      end
    end

    for i in 1..198
      file = File.read("public/temp_#{i}.json")
      verbs_conj = JSON.parse(file)
      verbs_conj.each do |verb|
        if not_in_db.include?(verb["infinitive"]) 
          v = Verb.new(:infinitive => verb["infinitive"], :translation => verb["translation"], :group => verb["group"])
          if v.save
            @tenses.each_with_index do |tense, index|
              @forms.each_with_index do |form, index2|
                if(verb[tense.to_s][form.to_s].strip != '')
                  @form = Form.new(:content => verb[tense.to_s][form.to_s], :temp => index.to_i, :person => index2.to_i,:verb => v)
                  @form.save
                end
              end
            end
          end
        end
      end
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
