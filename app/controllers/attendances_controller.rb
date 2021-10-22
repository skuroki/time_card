class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[ edit update destroy ]

  # GET /attendances or /attendances.json
  def index
    @attendances = Attendance.all

    last_attendance = @attendances.last
    if last_attendance.nil? || last_attendance.clock_out
      @state = :not_at_work
      @attendance = Attendance.new
    else
      last_rest = last_attendance.rests.last
      if last_rest.nil? || last_rest.rest_finish
        @state = :at_work
        @rest = last_attendance.rests.build
        @clock_out = last_attendance.build_clock_out
      else
        @state = :on_a_break
        @rest_finish = last_rest.build_rest_finish
      end
    end
  end

  # GET /attendances/1/edit
  def edit
  end

  # POST /attendances or /attendances.json
  def create
    @attendance = Attendance.new(attendance_params)

    respond_to do |format|
      if @attendance.save
        format.html { redirect_back fallback_location: root_path, notice: "Attendance was successfully created." }
        format.json { render :show, status: :created, location: @attendance }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /attendances/1 or /attendances/1.json
  def update
    respond_to do |format|
      if @attendance.update(attendance_params)
        format.html { redirect_to @attendance, notice: "Attendance was successfully updated." }
        format.json { render :show, status: :ok, location: @attendance }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @attendance.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /attendances/1 or /attendances/1.json
  def destroy
    @attendance.destroy
    respond_to do |format|
      format.html { redirect_to attendances_url, notice: "Attendance was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def report
    @attendances = Attendance.all
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attendance
      @attendance = Attendance.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def attendance_params
      params.require(:attendance).permit(:work_date, :started_at)
    end
end
