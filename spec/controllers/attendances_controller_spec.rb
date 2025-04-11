require 'rails_helper'

describe AttendancesController, type: :controller do
  render_views

  before do
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Basic.encode_credentials('skuroki', ENV['TIME_CARD_PASSWORD'])
  end

  describe 'GET #report' do
    it 'assigns the correct attendances for the target month' do
      target_month = 7.days.ago
      attendance1 = Attendance.create!(work_date: target_month.beginning_of_month + 1.day, started_at: Time.current)
      attendance2 = Attendance.create!(work_date: target_month.end_of_month - 1.day, started_at: Time.current)
      attendance_outside = Attendance.create!(work_date: target_month.end_of_month + 1.day, started_at: Time.current)

      get :report

      expect(response.body).to include(attendance1.work_date.to_s)
      expect(response.body).to include(attendance2.work_date.to_s)
      expect(response.body).not_to include(attendance_outside.work_date.to_s)
    end
  end
end
