class ClockOutsController < ApplicationController
  before_action :set_clock_out, only: %i[edit update destroy]

  # GET /clock_outs/1/edit
  def edit
    render partial: 'clock_outs/edit',
           locals: { clock_out: @clock_out }
  end

  # POST /clock_outs or /clock_outs.json
  def create
    @clock_out = ClockOut.new(clock_out_params)

    respond_to do |format|
      if @clock_out.save
        format.html { render_attendances_partial }
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
        format.html { render_attendances_partial }
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
      format.html { render_attendances_partial }
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
