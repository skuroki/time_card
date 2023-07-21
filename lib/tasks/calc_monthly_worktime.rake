task calc_monthly_worktime: :environment do
  year = 2022
  (1..12).each do |month|
    target_month = Date.new(year, month, 1)
    attendances = Attendance.where(work_date: target_month.beginning_of_month..target_month.end_of_month).order(:work_date)
    time = attendances.map(&:length).sum.then { |t| (t / 3600.0).round(2) }
    puts "#{year}年#{month}月,#{time}"
  end
end
