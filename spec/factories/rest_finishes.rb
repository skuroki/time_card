FactoryBot.define do
  factory :rest_finish do
    transient do
      rest_record { nil }
    end
    
    rest do
      rest_record || create(:rest)
    end
    
    finished_at do
      if rest
        Time.zone.local(
          rest.started_at.year,
          rest.started_at.month,
          rest.started_at.day,
          Time.zone.now.hour,
          Time.zone.now.min,
          Time.zone.now.sec
        )
      else
        Time.current
      end
    end
    
    initialize_with do
      RestFinish.new(rest: rest)
    end
  end
end
