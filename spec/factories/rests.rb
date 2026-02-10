FactoryBot.define do
  factory :rest do
    transient do
      attendance_record { nil }
    end
    
    attendance do
      attendance_record || create(:attendance)
    end
    
    started_at do
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
      Rest.new(attendance: attendance)
    end
    
    trait :with_finish do
      after(:create) do |rest|
        create(:rest_finish, rest_record: rest)
      end
    end
  end
end
