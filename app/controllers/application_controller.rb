class ApplicationController < ActionController::Base
  http_basic_authenticate_with name: 'skuroki', password: ENV['TIME_CARD_PASSWORD']

  def render_attendances_partial
    render partial: 'attendances/attendances',
           locals: { attendances: Attendance.recent,
                     last_attendance: Attendance.last }
  end
end
