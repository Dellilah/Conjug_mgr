class TranslationsController < ApplicationController
  before_action :authenticate_user!
  before_action :transl_count
  before_action :set_translation, only: [:show, :edit, :update, :destroy]

  # GET /translations
  # GET /translations.json
  def index
    @translations = Translation.all
  end

  # GET /translations/1
  # GET /translations/1.json
  def show
  end

  def accept
    @translation = Translation.find(params[:id])
    @verb = @translation.verb
    @verb.update(:translation => @translation.content)
    @translation.destroy
    respond_to do |format|
      format.html { redirect_to translations_url }
      format.json { head :no_content }
    end 
  end

  # GET /translations/new
  def new
    @translation = Translation.new
  end

  # GET /translations/1/edit
  def edit
  end

  # POST /translations
  # POST /translations.json
  def create
    @translation = Translation.new(:content => params[:transl], :verb_id => params[:id], :user_id => current_user.id)

    respond_to do |format|
      if @translation.save
        format.html { redirect_to @translation.verb, notice: 'Thanks for your advice!' }
        format.json { redirect_to controller: "verbs", action: 'show', location: @translation.verb }
      else
        format.html { render action: 'new' }
        format.json { render json: @translation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /translations/1
  # PATCH/PUT /translations/1.json
  def update
    respond_to do |format|
      if @translation.update(translation_params)
        format.html { redirect_to @translation, notice: 'Translation was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @translation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /translations/1
  # DELETE /translations/1.json
  def destroy
    @translation.destroy
    respond_to do |format|
      format.html { redirect_to translations_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_translation
      @translation = Translation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def translation_params
      params.require(:translation).permit(:content)
    end
end
