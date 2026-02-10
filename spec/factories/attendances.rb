FactoryBot.define do
  factory :attendance do
    work_date { Date.current }
    started_at { Time.current }
    
    trait :with_clock_out do
      after(:create) do |attendance|
        create(:clock_out, attendance_record: attendance)
      end
    end
    
    trait :with_rest do
      after(:create) do |attendance|
        create(:rest, attendance_record: attendance)
      end
    end
    
    trait :with_completed_rest do
      after(:create) do |attendance|
        rest = create(:rest, attendance_record: attendance)
        create(:rest_finish, rest_record: rest)
      end
    end
  end
end
