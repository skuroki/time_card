FactoryBot.define do
  factory :clock_out do
    transient do
      attendance_record { nil }
    end
    
    attendance do
      attendance_record || create(:attendance)
    end
    
    finished_at do
      if attendance
        Time.zone.local(
          attendance.started_at.year,
          attendance.started_at.month,
          attendance.started_at.day,
          Time.zone.now.hour,
          Time.zone.now.min,
          Time.zone.now.sec
        )
      else
        Time.current
      end
    end
    
    initialize_with do
      ClockOut.new(attendance: attendance)
    end
  end
end
