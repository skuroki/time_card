class RestFinishesController < ApplicationController
  before_action :set_rest_finish, only: %i[ show edit update destroy ]

  # GET /rest_finishes or /rest_finishes.json
  def index
    @rest_finishes = RestFinish.all
  end

  # GET /rest_finishes/1 or /rest_finishes/1.json
  def show
  end

  # GET /rest_finishes/new
  def new
    @rest_finish = RestFinish.new
  end

  # GET /rest_finishes/1/edit
  def edit
  end

  # POST /rest_finishes or /rest_finishes.json
  def create
    @rest_finish = RestFinish.new(rest_finish_params)

    respond_to do |format|
      if @rest_finish.save
        format.html { redirect_to @rest_finish, notice: "Rest finish was successfully created." }
        format.json { render :show, status: :created, location: @rest_finish }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rest_finish.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rest_finishes/1 or /rest_finishes/1.json
  def update
    respond_to do |format|
      if @rest_finish.update(rest_finish_params)
        format.html { redirect_to @rest_finish, notice: "Rest finish was successfully updated." }
        format.json { render :show, status: :ok, location: @rest_finish }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rest_finish.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rest_finishes/1 or /rest_finishes/1.json
  def destroy
    @rest_finish.destroy
    respond_to do |format|
      format.html { redirect_to rest_finishes_url, notice: "Rest finish was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rest_finish
      @rest_finish = RestFinish.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rest_finish_params
      params.require(:rest_finish).permit(:rest_id, :finished_at)
    end
end
