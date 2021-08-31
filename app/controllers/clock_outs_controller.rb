class ClockOutsController < ApplicationController
  before_action :set_clock_out, only: %i[ show edit update destroy ]

  # GET /clock_outs or /clock_outs.json
  def index
    @clock_outs = ClockOut.all
  end

  # GET /clock_outs/1 or /clock_outs/1.json
  def show
  end

  # GET /clock_outs/new
  def new
    @clock_out = ClockOut.new
  end

  # GET /clock_outs/1/edit
  def edit
  end

  # POST /clock_outs or /clock_outs.json
  def create
    @clock_out = ClockOut.new(clock_out_params)

    respond_to do |format|
      if @clock_out.save
        format.html { redirect_to @clock_out, notice: "Clock out was successfully created." }
        format.json { render :show, status: :created, location: @clock_out }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @clock_out.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /clock_outs/1 or /clock_outs/1.json
  def update
    respond_to do |format|
      if @clock_out.update(clock_out_params)
        format.html { redirect_to @clock_out, notice: "Clock out was successfully updated." }
        format.json { render :show, status: :ok, location: @clock_out }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @clock_out.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clock_outs/1 or /clock_outs/1.json
  def destroy
    @clock_out.destroy
    respond_to do |format|
      format.html { redirect_to clock_outs_url, notice: "Clock out was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_clock_out
      @clock_out = ClockOut.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def clock_out_params
      params.require(:clock_out).permit(:attendance_id, :finished_at)
    end
end
