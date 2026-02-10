require 'rails_helper'

RSpec.describe 'Attendance Workflow', type: :system do
  before do
    sign_in_with_basic_auth
  end

  describe 'complete clock-in to clock-out workflow' do
    it 'allows user to clock in, take rest, and clock out' do
      visit attendances_path
      
      # Initially, should show the clock-in form
      expect(page).to have_content('勤務を開始する')
      
      # Clock in - just submit with default values (today's date and current time)
      within('turbo-frame#form') do
        click_button 'Create Attendance'
      end
      
      # Wait for Turbo Frame to update
      sleep 1
      
      # After clocking in, should show rest and clock-out forms
      expect(page).to have_button('Create Rest')
      expect(page).to have_button('Create Clock out')
      
      # Start rest
      within('turbo-frame#form') do
        click_button 'Create Rest'
      end
      
      # Wait for Turbo Frame to update
      sleep 1
      
      # After starting rest, should show rest finish form
      expect(page).to have_button('Create Rest finish')
      
      # End rest
      within('turbo-frame#form') do
        click_button 'Create Rest finish'
      end
      
      # Wait for Turbo Frame to update
      sleep 1
      
      # After ending rest, should show rest and clock-out forms again
      expect(page).to have_button('Create Rest')
      expect(page).to have_button('Create Clock out')
      
      # Clock out
      within('turbo-frame#form') do
        click_button 'Create Clock out'
      end
      
      # Wait for Turbo Frame to update
      sleep 1
      
      # After clocking out, should show clock-in form again
      expect(page).to have_content('勤務を開始する')
      
      # Verify the attendance record was created with all data
      attendance = Attendance.last
      expect(attendance).to be_present
      expect(attendance.clock_out).to be_present
      expect(attendance.rests.count).to eq(1)
      expect(attendance.rests.first.rest_finish).to be_present
    end
  end

  describe 'simple clock-in and clock-out workflow' do
    it 'allows user to clock in and clock out without rest' do
      visit attendances_path
      
      # Clock in with default values
      within('turbo-frame#form') do
        expect(page).to have_content('勤務を開始する')
        click_button 'Create Attendance'
      end
      
      # Wait for Turbo Frame to update
      sleep 1
      
      # Should show clock-out option
      expect(page).to have_button('Create Clock out')
      
      # Clock out directly without taking rest
      within('turbo-frame#form') do
        click_button 'Create Clock out'
      end
      
      # Wait for Turbo Frame to update
      sleep 1
      
      # Should return to clock-in form
      expect(page).to have_content('勤務を開始する')
      
      # Verify attendance was created without rest
      attendance = Attendance.last
      expect(attendance).to be_present
      expect(attendance.clock_out).to be_present
      expect(attendance.rests.count).to eq(0)
    end
  end

  describe 'multiple rest periods' do
    it 'allows user to take multiple rest periods during work' do
      visit attendances_path
      
      # Clock in
      within('turbo-frame#form') do
        click_button 'Create Attendance'
      end
      
      sleep 1
      
      # Take first rest
      within('turbo-frame#form') do
        click_button 'Create Rest'
      end
      
      sleep 1
      expect(page).to have_button('Create Rest finish')
      
      within('turbo-frame#form') do
        click_button 'Create Rest finish'
      end
      
      sleep 1
      
      # Take second rest
      expect(page).to have_button('Create Rest')
      
      within('turbo-frame#form') do
        click_button 'Create Rest'
      end
      
      sleep 1
      expect(page).to have_button('Create Rest finish')
      
      within('turbo-frame#form') do
        click_button 'Create Rest finish'
      end
      
      sleep 1
      
      # Verify multiple rest periods
      attendance = Attendance.last
      expect(attendance.rests.count).to eq(2)
      expect(attendance.rests.all? { |r| r.rest_finish.present? }).to be true
    end
  end

  describe 'error handling' do
    it 'prevents creating rest when not clocked in' do
      visit attendances_path
      
      # Should only show clock-in form, not rest form
      expect(page).to have_content('勤務を開始する')
      expect(page).not_to have_button('Create Rest')
    end
    
    it 'prevents ending rest when not on break' do
      visit attendances_path
      
      # Clock in
      within('turbo-frame#form') do
        click_button 'Create Attendance'
      end
      
      sleep 1
      
      # Should not show rest finish button when not on break
      expect(page).not_to have_button('Create Rest finish')
      expect(page).to have_button('Create Rest')
    end
    
    it 'prevents clocking out when on break' do
      visit attendances_path
      
      # Clock in
      within('turbo-frame#form') do
        click_button 'Create Attendance'
      end
      
      sleep 1
      
      # Start rest
      within('turbo-frame#form') do
        click_button 'Create Rest'
      end
      
      sleep 1
      
      # Should not show clock-out button when on break
      expect(page).not_to have_button('Create Clock out')
      expect(page).to have_button('Create Rest finish')
    end
  end
end
