class VerbsController < ApplicationController
  before_action :set_verb, only: [:show, :edit, :update, :destroy]
  before_action :set_tenses, only: [:new, :create, :show, :edit, :update, :download, :download_from_json, :look_for_conj, :practice, :practice_draw, :check_form, :search]
  before_filter :authenticate_user!, :except => [:show, :practice, :practice_draw, :check_form, :index]
  helper_method :get_interval

  # GET /verbs
  # GET /verbs.json
  def index
    @groupes = ['1','2','3']
    if params[:groupes]
      @groupes = params[:groupes]
      @verbs =  Verb.find(:all, :conditions =>["`group` IN (?)", @groupes]).group_by{|u| u.infinitive[0]}
    else
      @verbs = Verb.all.group_by{|u| u.infinitive[0]}
    end
  end

  # GET /verbs/1
  # GET /verbs/1.json
  def show
    @verb_forms = @verb.forms
    @verb_forms_tab = Hash.new
    @tenses.each_with_index do |tense, index|
      @verb_forms_tab[tense] = Hash.new
      @forms.each_with_index do |form, index2|
        temp = @verb_forms.where(:temp => index.to_i, :person => index2.to_i).first
        @verb_forms_tab[tense][form] = temp ? temp.content : ''
      end
    end

  end

  # GET /verbs/new
  def new
    @verb = Verb.new
  end

  # GET /verbs/1/edit
  def edit
  end

  # POST /verbs
  # POST /verbs.json
  def create
    @verb = Verb.new(:infinitive => verb_params[:infinitive], :translation => verb_params[:translation], :group => verb_params[:group])
    if @verb.save
      @tenses.each_with_index do |tense, index|
        @forms.each_with_index do |form, index2|
          if(verb_params[tense][form].strip != '')
            @form = Form.new(:content => verb_params[tense][form], :temp => index.to_i, :person => index2.to_i,:verb => @verb)
            @form.save
          end
        end
      end
    end

    respond_to do |format|
      if @verb.save
        format.html { redirect_to @verb, notice: 'Verb was successfully created.' }
        format.json { render action: 'show', status: :created, location: @verb }
      else
        format.html { render action: 'new' }
        format.json { render json: @verb.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /verbs/1
  # PATCH/PUT /verbs/1.json
  def update
    respond_to do |format|
      if @verb.update(verb_params)
        format.html { redirect_to @verb, notice: 'Verb was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @verb.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /verbs/1
  # DELETE /verbs/1.json
  def destroy
    @verb.destroy
    respond_to do |format|
      format.html { redirect_to verbs_url }
      format.json { head :no_content }
    end
  end

  def download
    page = params[:page].to_i

    a = download_conjugation(page)
    @verbs_conj.each do |verb|
      v = Verb.new(:infinitive => verb[:infinitive], :translation => verb[:translation], :group => verb[:group])
      if v.save
        @tenses.each_with_index do |tense, index|
          @forms.each_with_index do |form, index2|
            if(verb[tense][form].strip != '')
              @form = Form.new(:content => verb[tense][form], :temp => index.to_i, :person => index2.to_i,:verb => v)
              @form.save
            end
          end
        end
      end
    end
    File.open("public/temp_#{page}.json","w") do |f|
      f.write(JSON.pretty_generate(@verbs_conj))
    end

    @verbs = Verb.all
    respond_to do |format|
      format.html{ render action: 'index'}
      format.json { head :no_content }
    end

  end

  def search
    @search_form = params[:search]
    # we have to take care of auxiliary verbs
    # we assume that user is not looking for the form of etre or avoir
    flag = 0
    exact_forms = Form.where(content: @search_form)

    @exact_verbs = Array.new()
    @similar_verbs = Array.new()
    @infinitives = Verb.find(:all, :conditions => ["infinitive LIKE ?", "%#{@search_form}%"])

    if exact_forms
      exact_forms.each_with_index do |form, index|
        # We need to know which verb and which tense is it
        v = Array.new()
        a = Verb.find(form.verb_id)
        v.push(Verb.find(form.verb_id))
        v.push(@tenses[form.temp])
        v.push(@forms[form.person].to_s + " " +form.content)
        @exact_verbs.push(v)
        if a.infinitive == "être" || a.infinitive == "avoir"
          flag = 1
        end
      end
    end

    if flag == 0
      similar_forms = Form.find(:all, :conditions => ["content LIKE ?", "%#{@search_form}%"])
      similar_forms = similar_forms - exact_forms
    
      if similar_forms
        similar_forms.each_with_index do |form, index|
          v = Array.new()
          v. push(Verb.find(form.verb_id))
          v.push(@tenses[form.temp])
          v.push(@forms[form.person].to_s + " " +form.content)
          @similar_verbs.push(v)
        end
      end
    end    
  end



  def look_for_conj
    verb = download_verb_conjugation(params[:verb])
    v = Verb.new(:infinitive => verb[:infinitive], :translation => verb[:translation], :group => verb[:group])
    if v.save
      @tenses.each_with_index do |tense, index|
        @forms.each_with_index do |form, index2|
          if(verb[tense][form].strip != '')
            @form = Form.new(:content => verb[tense][form], :temp => index.to_i, :person => index2.to_i,:verb => v)
            @form.save

          end
        end
      end
    end
    respond_to do |format|
      if v.save
        format.html { redirect_to v, notice: 'Verb was successfully created.' }
        format.json { render action: 'show', status: :created, location: v }
      else
        format.html { render action: 'new' }
        format.json { render json: v.errors, status: :unprocessable_entity }
      end
    end
  end

  def download_from_json
    page = params[:page].to_i

    for i in 0..10
      file = File.read("public/temp_#{page}.json")
      verbs_conj = JSON.parse(file)
      verbs_conj.each do |verb|
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
      page = page+1
    end

    respond_to do |format|
      format.html{ redirect_to action: 'index'}
      format.json { head :no_content }
    end
  end

  def practice
  end

  def practice_draw

    if !defined? params[:tenses] || (!defined? params[:groupes] && @excl_to_pr.empty? && @add_to_pr.empty?)
      puts "NIC NIE WYBRANO"
    end

    @tenses_to_pr = Array.new()
    params[:tenses].each do |key, val|
      @tenses_to_pr.push(val)
    end
    @gr_to_pr = params[:groupes]
    @excl_to_pr = params[:exluded_verbs].length > 0 ? params[:exluded_verbs].split(', ') : ''
    @add_to_pr = params[:verbs].length > 0 ? params[:verbs].split(', ') : ''

    #which verbs
    @verbs_to_pr =  Verb.find(:all, :conditions =>
      ["(`group` IN (?) AND `infinitive` NOT IN (?)) OR `infinitive` IN (?) ",
      @gr_to_pr, @excl_to_pr, @add_to_pr ])

    # we are going to save all forms ids suitable to conditions
    @forms_ids = Form.find(:all, :conditions =>
        ["`temp` IN (?) AND `verb_id` IN (?)", @tenses_to_pr, @verbs_to_pr ])

    # if the user is logged we have to divide forms into 3 groups: 
    # A) never ever checked, B) "outdated", C) the rest of the world
    if current_user
      # we need flag to change verbs: A <=> B (ew. C)
      @flag = "A"
      @forms_A = Array.new()
      @forms_B = Array.new()
      @forms_C = Array.new()
      @forms_ids.each do |form|
        if r = Repetition.where(:form_id => form.id, :user_id => current_user.id).first
          if r.next < Time.now
            @forms_C.push(form.id)
          else
            @forms_B.push(form.id)
          end
        else
          @forms_A.push(form.id)
        end 
      end
    end

    # if not logged - drawing from the whole group of fomrs
    @f = @forms_ids.sample
    @v = Verb.find(@f.verb_id)

    #let's save forms with its ids
    @forms_to_pr_id = Array.new()
    @forms_ids.each do |v|
      @forms_to_pr_id.push(v.id)
    end

  end

  def check_form

    #save previous forms
    @f_old = Form.find(params[:form])
    @v_old = Verb.find(@f_old.verb_id)

    # the whole table of ids of forms to practice
    @forms_to_pr_id = params[:forms_to_pr_id]

    #check q for the previous answer
    @q = params[:q].to_i
    #check answer
    @answer = params[:answer]
    # @full_form = Form.where(:temp => @t_old, :person => @p_old, :verb_id => @v_old).first
    @correct = @f_old.content
    if @answer ==  @correct
      @result = 1
    else
      @result = 0
    end

    # for logged users - we've got to save their result from the previous try
    #                 AND rewrite the forms A,B,C
    #                 AND choose next verb
    if current_user

      @forms_A = params[:forms_A].split
      @forms_B = params[:forms_B].split
      @forms_C = params[:forms_C].split
      @flag = params[:flag]
      if @flag == "A"
        @forms_C.push(@f_old.id)
        @forms_A.delete(@f_old.id.to_s)
        if @forms_B.empty? && @forms_A.empty?
          @flag = "C"
        elsif !@forms_B.empty?
          @flag = "B"
        end
      elsif @flag == "B"
        @forms_C.push(@f_old.id)
        @forms_B.delete(@f_old.id.to_s)
        if @forms_B.empty? && @forms_A.empty?
          @flag = "C"
        elsif !@forms_A.empty?
          @flag = "A"
        end
      end
      case @flag
      when "A"
        @f = Form.find(@forms_A.sample.to_i)
      when "B"
        r = Repetition.where(:form_id => @forms_B,:user_id => current_user.id).order("next ASC").first
        @f = Form.find(r.form_id)
      when "C"
        r = Repetition.where(:form_id => @forms_C,:user_id => current_user.id).order("next ASC").first
        @f = Form.find(r.form_id)
      end

      @r = Repetition.where(:form_id => params[:full_form_id], :user_id => current_user.id).first
      if @r
        @r.count += 1
        @r.n += 1
      else
        @r = Repetition.new(:form_id => params[:full_form_id], :user_id => current_user.id)
        @r.n = 1
      end
      @r.save
      if @q && @q > 2
        @r.ef = @r.ef - 0.8 + 0.28 * @q - 0.02 * @q * @q 
        if @r.ef <1.3
          @r.ef = 1.3
        end
        if @r.n == 1
          i = 1
        elsif @r.n == 2
          i = 6
        else
          i = @r.interval * @r.ef
        end
        @r.remembered = 1
        @r.next = Time.now + i.days
        @r.interval = i
        # we have to find the interval
      elsif @q != 0 
        case @q
        when 1
          i =1
          @r.n = 1
        when 2
          i = 6
          @r.n = 2
        end
        @r.remembered = 0
        @r.next = Time.now + i.days
        @r.interval = i
      end
      @r.save
    else

      @f = Form.find(:all, :conditions => ["`id` IN (?)", @forms_to_pr_id.split]).sample
    
    end

    @v = Verb.find(@f.verb_id)

    respond_to do |format|
      format.html{ render :practice_draw}
      format.json { head :no_content }
    end

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_verb
      @verb = Verb.find(params[:id])
    end

    def set_tenses
      @tenses = [:présent, :passé_composé, :imparfait, :plus_que_parfait,
        :passé_simple, :passé_antérieur, :futur_simple, :futur_antérieur,:subjonctif_présent,
        :subjonctif_passé,:subjonctif_imparfait, :subjonctif_plus_que_parfait, :conditionnel_présent, :conditionnel_passé_première, :conditionnel_passé_deuxième]
      @forms = [:je, :tu, :il, :nous, :vous, :ils]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def verb_params
      @forms = [:je, :tu, :il, :nous, :vous, :ils]
      @t = [:présent  => @forms, :passé_composé => @forms, :imparfait => @forms, :plus_que_parfait => @forms,
        :passé_simple => @forms, :passé_antérieur => @forms, :futur_simple => @forms, :futur_antérieur => @forms,:subjonctif_présent => @forms,
        :subjonctif_passé => @forms,:subjonctif_imparfait => @forms, :subjonctif_plus_que_parfait => @forms, :conditionnel_présent => @forms, :conditionnel_passé_première => @forms, :conditionnel_passé_deuxième => @forms]
      @par = [:infinitive, :translation, :group].concat(@t)
      params.require(:verb).permit(@par)
    end

    def get_interval
      if @r.n == 1
        return 1.0
      elsif @r.n == 2
        return 6.0
      else
        return @r.interval*get_ef
      end
    end


end
