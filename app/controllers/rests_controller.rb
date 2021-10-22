class RestsController < ApplicationController
  before_action :set_rest, only: %i[ edit update destroy ]

  # GET /rests/1/edit
  def edit
  end

  # POST /rests or /rests.json
  def create
    @rest = Rest.new(rest_params)

    respond_to do |format|
      if @rest.save
        format.html { redirect_back fallback_location: root_path, notice: "Rest was successfully created." }
        format.json { render :show, status: :created, location: @rest }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @rest.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /rests/1 or /rests/1.json
  def update
    respond_to do |format|
      if @rest.update(rest_params)
        format.html { redirect_to root_path, notice: "Rest was successfully updated." }
        format.json { render :show, status: :ok, location: @rest }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @rest.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /rests/1 or /rests/1.json
  def destroy
    @rest.destroy
    respond_to do |format|
      format.html { redirect_to rests_url, notice: "Rest was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_rest
      @rest = Rest.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def rest_params
      params.require(:rest).permit(:attendance_id, :started_at)
    end
end
