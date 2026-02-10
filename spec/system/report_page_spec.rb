require 'rails_helper'

RSpec.describe 'Report Page', type: :system do
  before do
    # Sign in with basic auth before each test
    sign_in_with_basic_auth
  end

  describe 'displaying current month attendances' do
    it 'displays attendance records for the current month' do
      # Create attendances for the current month (7 days ago to account for reporting period)
      target_month = 7.days.ago
      start_of_month = target_month.beginning_of_month
      
      # Create 5 attendances with complete data
      attendances = []
      5.times do |i|
        work_date = start_of_month + i.days
        attendance = create(:attendance, 
          work_date: work_date,
          started_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 9, 0, 0)
        )
        
        # Add a rest period
        rest = create(:rest, 
          attendance: attendance,
          started_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 12, 0, 0)
        )
        create(:rest_finish, 
          rest: rest,
          finished_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 13, 0, 0)
        )
        
        # Add clock out
        create(:clock_out, 
          attendance: attendance,
          finished_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 18, 0, 0)
        )
        
        attendances << attendance
      end
      
      visit report_attendances_path
      
      # Verify page has the table structure
      expect(page).to have_selector('table')
      expect(page).to have_selector('thead')
      expect(page).to have_selector('tbody')
      
      # Verify table headers
      expect(page).to have_content('日付')
      expect(page).to have_content('開始')
      expect(page).to have_content('休憩')
      expect(page).to have_content('終了')
      expect(page).to have_content('勤務時間')
      
      # Verify all 5 attendance records are displayed
      expect(page).to have_selector('table tbody tr', count: 6) # 5 records + 1 total row
      
      # Verify each attendance is displayed with correct data
      attendances.each do |attendance|
        expect(page).to have_content(attendance.work_date.to_s)
        expect(page).to have_content('09:00') # start time
        expect(page).to have_content('12:00') # rest start
        expect(page).to have_content('13:00') # rest end
        expect(page).to have_content('18:00') # clock out time
      end
      
      # Verify working hours are displayed (9 hours - 1 hour rest = 8 hours)
      expect(page).to have_content('08:00')
      
      # Verify total row exists
      expect(page).to have_content('合計')
    end

    it 'displays attendances without rest periods' do
      target_month = 7.days.ago
      work_date = target_month.beginning_of_month
      
      # Create attendance without rest
      attendance = create(:attendance,
        work_date: work_date,
        started_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 9, 0, 0)
      )
      create(:clock_out,
        attendance: attendance,
        finished_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 17, 0, 0)
      )
      
      visit report_attendances_path
      
      # Verify attendance is displayed (check for formatted date, not full timestamp)
      expect(page).to have_content(work_date.strftime('%Y-%m-%d'))
      expect(page).to have_content('09:00')
      expect(page).to have_content('17:00')
      
      # Verify working hours (8 hours with no rest)
      expect(page).to have_content('08:00')
    end

    it 'displays attendances with multiple rest periods' do
      target_month = 7.days.ago
      work_date = target_month.beginning_of_month
      
      # Create attendance with two rest periods
      attendance = create(:attendance,
        work_date: work_date,
        started_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 9, 0, 0)
      )
      
      # First rest period
      rest1 = create(:rest,
        attendance: attendance,
        started_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 12, 0, 0)
      )
      create(:rest_finish,
        rest: rest1,
        finished_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 12, 30, 0)
      )
      
      # Second rest period
      rest2 = create(:rest,
        attendance: attendance,
        started_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 15, 0, 0)
      )
      create(:rest_finish,
        rest: rest2,
        finished_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 15, 30, 0)
      )
      
      create(:clock_out,
        attendance: attendance,
        finished_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 18, 0, 0)
      )
      
      visit report_attendances_path
      
      # Verify both rest periods are displayed
      expect(page).to have_content('12:00 - 12:30')
      expect(page).to have_content('15:00 - 15:30')
      
      # Verify working hours (9 hours - 1 hour rest = 8 hours)
      expect(page).to have_content('08:00')
    end
  end

  describe 'month filtering functionality' do
    it 'only displays attendances from the target month' do
      target_month = 7.days.ago
      
      # Create attendance in the target month
      current_month_date = target_month.beginning_of_month + 5.days
      current_attendance = create(:attendance,
        work_date: current_month_date,
        started_at: Time.zone.local(current_month_date.year, current_month_date.month, current_month_date.day, 9, 0, 0)
      )
      create(:clock_out,
        attendance: current_attendance,
        finished_at: Time.zone.local(current_month_date.year, current_month_date.month, current_month_date.day, 17, 0, 0)
      )
      
      # Create attendance from 2 months ago (should not appear)
      old_date = target_month - 2.months
      old_attendance = create(:attendance,
        work_date: old_date,
        started_at: Time.zone.local(old_date.year, old_date.month, old_date.day, 9, 0, 0)
      )
      create(:clock_out,
        attendance: old_attendance,
        finished_at: Time.zone.local(old_date.year, old_date.month, old_date.day, 17, 0, 0)
      )
      
      # Create attendance from next month (should not appear)
      future_date = target_month + 2.months
      future_attendance = create(:attendance,
        work_date: future_date,
        started_at: Time.zone.local(future_date.year, future_date.month, future_date.day, 9, 0, 0)
      )
      create(:clock_out,
        attendance: future_attendance,
        finished_at: Time.zone.local(future_date.year, future_date.month, future_date.day, 17, 0, 0)
      )
      
      visit report_attendances_path
      
      # Verify only current month attendance is displayed (use formatted dates)
      expect(page).to have_content(current_month_date.strftime('%Y-%m-%d'))
      expect(page).not_to have_content(old_date.strftime('%Y-%m-%d'))
      expect(page).not_to have_content(future_date.strftime('%Y-%m-%d'))
      
      # Should only have 2 rows (1 attendance + 1 total)
      expect(page).to have_selector('table tbody tr', count: 2)
    end

    it 'handles empty month with no attendances' do
      # Don't create any attendances
      visit report_attendances_path
      
      # Should still show the table structure
      expect(page).to have_selector('table')
      expect(page).to have_content('日付')
      
      # Should only have the total row
      expect(page).to have_selector('table tbody tr', count: 1)
      expect(page).to have_content('合計')
    end
  end

  describe 'working hours calculation' do
    it 'calculates total working hours correctly' do
      target_month = 7.days.ago
      start_of_month = target_month.beginning_of_month
      
      # Create 3 attendances with different working hours
      # Day 1: 8 hours (9:00 - 18:00, 1 hour rest)
      date1 = start_of_month
      att1 = create(:attendance,
        work_date: date1,
        started_at: Time.zone.local(date1.year, date1.month, date1.day, 9, 0, 0)
      )
      rest1 = create(:rest,
        attendance: att1,
        started_at: Time.zone.local(date1.year, date1.month, date1.day, 12, 0, 0)
      )
      create(:rest_finish,
        rest: rest1,
        finished_at: Time.zone.local(date1.year, date1.month, date1.day, 13, 0, 0)
      )
      create(:clock_out,
        attendance: att1,
        finished_at: Time.zone.local(date1.year, date1.month, date1.day, 18, 0, 0)
      )
      
      # Day 2: 7 hours (9:00 - 17:00, 1 hour rest)
      date2 = start_of_month + 1.day
      att2 = create(:attendance,
        work_date: date2,
        started_at: Time.zone.local(date2.year, date2.month, date2.day, 9, 0, 0)
      )
      rest2 = create(:rest,
        attendance: att2,
        started_at: Time.zone.local(date2.year, date2.month, date2.day, 12, 0, 0)
      )
      create(:rest_finish,
        rest: rest2,
        finished_at: Time.zone.local(date2.year, date2.month, date2.day, 13, 0, 0)
      )
      create(:clock_out,
        attendance: att2,
        finished_at: Time.zone.local(date2.year, date2.month, date2.day, 17, 0, 0)
      )
      
      # Day 3: 6 hours (10:00 - 16:00, no rest)
      date3 = start_of_month + 2.days
      att3 = create(:attendance,
        work_date: date3,
        started_at: Time.zone.local(date3.year, date3.month, date3.day, 10, 0, 0)
      )
      create(:clock_out,
        attendance: att3,
        finished_at: Time.zone.local(date3.year, date3.month, date3.day, 16, 0, 0)
      )
      
      visit report_attendances_path
      
      # Verify individual working hours
      within('table tbody') do
        rows = all('tr')
        
        # First attendance: 8 hours
        expect(rows[0]).to have_content('08:00')
        
        # Second attendance: 7 hours
        expect(rows[1]).to have_content('07:00')
        
        # Third attendance: 6 hours
        expect(rows[2]).to have_content('06:00')
        
        # Total row: 21 hours
        expect(rows[3]).to have_content('合計')
        expect(rows[3]).to have_content('21:')
      end
    end

    it 'handles attendances without clock out' do
      target_month = 7.days.ago
      work_date = target_month.beginning_of_month
      
      # Create attendance without clock out (incomplete work day)
      create(:attendance,
        work_date: work_date,
        started_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 9, 0, 0)
      )
      
      visit report_attendances_path
      
      # Should display the attendance but with 0 working hours (use formatted date)
      expect(page).to have_content(work_date.strftime('%Y-%m-%d'))
      expect(page).to have_content('09:00')
      
      # Working time should be 00:00 for incomplete attendance
      within('table tbody') do
        rows = all('tr')
        expect(rows[0]).to have_content('00:00')
      end
    end
  end

  describe 'data sorting and formatting' do
    it 'sorts attendances by work date in ascending order' do
      target_month = 7.days.ago
      start_of_month = target_month.beginning_of_month
      
      # Create attendances in random order
      dates = [
        start_of_month + 10.days,
        start_of_month + 2.days,
        start_of_month + 15.days,
        start_of_month + 5.days
      ]
      
      dates.each do |date|
        attendance = create(:attendance,
          work_date: date,
          started_at: Time.zone.local(date.year, date.month, date.day, 9, 0, 0)
        )
        create(:clock_out,
          attendance: attendance,
          finished_at: Time.zone.local(date.year, date.month, date.day, 17, 0, 0)
        )
      end
      
      visit report_attendances_path
      
      # Get all date cells in order
      date_cells = all('table tbody tr th').map(&:text).reject { |t| t == '合計' }
      
      # Verify dates are sorted (use formatted dates)
      sorted_dates = dates.sort.map { |d| d.strftime('%Y-%m-%d') }
      expect(date_cells).to eq(sorted_dates)
    end

    it 'formats times in HH:MM format' do
      target_month = 7.days.ago
      work_date = target_month.beginning_of_month
      
      attendance = create(:attendance,
        work_date: work_date,
        started_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 9, 15, 0)
      )
      
      rest = create(:rest,
        attendance: attendance,
        started_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 12, 30, 0)
      )
      create(:rest_finish,
        rest: rest,
        finished_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 13, 45, 0)
      )
      
      create(:clock_out,
        attendance: attendance,
        finished_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 18, 5, 0)
      )
      
      visit report_attendances_path
      
      # Verify time formatting
      expect(page).to have_content('09:15')
      expect(page).to have_content('12:30')
      expect(page).to have_content('13:45')
      expect(page).to have_content('18:05')
    end

    it 'displays rest periods with proper formatting' do
      target_month = 7.days.ago
      work_date = target_month.beginning_of_month
      
      attendance = create(:attendance,
        work_date: work_date,
        started_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 9, 0, 0)
      )
      
      rest = create(:rest,
        attendance: attendance,
        started_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 12, 0, 0)
      )
      create(:rest_finish,
        rest: rest,
        finished_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 13, 0, 0)
      )
      
      create(:clock_out,
        attendance: attendance,
        finished_at: Time.zone.local(work_date.year, work_date.month, work_date.day, 17, 0, 0)
      )
      
      visit report_attendances_path
      
      # Verify rest period is formatted as "start - end"
      expect(page).to have_content('12:00 - 13:00')
    end
  end
end
