class AttendancesController < ApplicationController
  before_action :set_attendance, only: %i[edit update destroy]

  # GET /attendances or /attendances.json
  def index
    @attendances = Attendance.recent
    @last_attendance = @attendances.last
  end

  # GET /attendances/1/edit
  def edit
    render partial: 'attendances/edit',
           locals: { attendance: @attendance }
  end

  # POST /attendances or /attendances.json
  def create
    @attendance = Attendance.new(attendance_params)

    respond_to do |format|
      if @attendance.save
        format.html { render_attendances_partial }
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
        format.html { render_attendances_partial }
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
      format.html { render_attendances_partial }
      format.json { head :no_content }
    end
  end

  def report
    # 翌月の7日くらいまでには報告書を出すという見込み
    target_month = 7.days.ago
    @attendances = Attendance.where(work_date: target_month.beginning_of_month..target_month.end_of_month).order(:work_date)
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
