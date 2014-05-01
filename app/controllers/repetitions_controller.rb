class RepetitionsController < ApplicationController
  before_action :set_repetition, only: [:show, :edit, :update, :destroy]

  # GET /repetitions
  # GET /repetitions.json
  def index
    @repetitions = Repetition.all
  end

  # GET /repetitions/1
  # GET /repetitions/1.json
  def show
  end

  # GET /repetitions/new
  def new
    @repetition = Repetition.new
  end

  # GET /repetitions/1/edit
  def edit
  end

  # POST /repetitions
  # POST /repetitions.json
  def create
    @repetition = Repetition.new(repetition_params)

    respond_to do |format|
      if @repetition.save
        format.html { redirect_to @repetition, notice: 'Repetition was successfully created.' }
        format.json { render action: 'show', status: :created, location: @repetition }
      else
        format.html { render action: 'new' }
        format.json { render json: @repetition.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /repetitions/1
  # PATCH/PUT /repetitions/1.json
  def update
    respond_to do |format|
      if @repetition.update(repetition_params)
        format.html { redirect_to @repetition, notice: 'Repetition was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @repetition.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /repetitions/1
  # DELETE /repetitions/1.json
  def destroy
    @repetition.destroy
    respond_to do |format|
      format.html { redirect_to repetitions_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_repetition
      @repetition = Repetition.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def repetition_params
      params.require(:repetition).permit(:last, :count, :mistake, :correct, :form_id, :user_id)
    end
end
