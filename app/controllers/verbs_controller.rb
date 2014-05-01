class VerbsController < ApplicationController
  before_action :set_verb, only: [:show, :edit, :update, :destroy]
  before_action :set_tenses, only: [:new, :create, :show, :edit, :update, :download, :look_for_conj]

  # GET /verbs
  # GET /verbs.json
  def index
    @verbs = Verb.all
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
    puts "hola"
    @verb["présent"] = Hash.new
    @verb["présent"]["je"] = "ala"
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
    a = download_conjugation(params[:page])
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
    @verbs = Verb.all
    respond_to do |format|
      format.html{ render action: 'index'}
      format.json { head :no_content }
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

    def practice
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


end
