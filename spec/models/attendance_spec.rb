require 'rails_helper'

RSpec.describe Attendance, type: :model do
  describe 'scopes' do
    it 'returns recent attendances' do
      old_attendance = Attendance.create!(work_date: 2.months.ago.to_date, started_at: 2.months.ago)
      recent_attendance = Attendance.create!(work_date: 1.week.ago.to_date, started_at: 1.week.ago)

      expect(Attendance.recent).to include(recent_attendance)
      expect(Attendance.recent).not_to include(old_attendance)
    end
  end

  describe 'callbacks' do
    it 'adjusts started_at before save' do
      attendance = Attendance.new(work_date: Date.today + 1.day, started_at: Time.zone.now)
      attendance.save

      expect(attendance.started_at).to eq(Time.zone.local(
                                            attendance.work_date.year,
                                            attendance.work_date.month,
                                            attendance.work_date.day,
                                            attendance.started_at.hour,
                                            attendance.started_at.min,
                                            attendance.started_at.sec
                                          ))
    end
  end

  describe 'instance methods' do
    describe '#length' do
      it 'calculates total worked time excluding rests' do
        attendance = Attendance.create!(work_date: Date.today, started_at: Time.zone.now - 2.hours)
        ClockOut.create!(attendance:, finished_at: attendance.started_at + 8.hours)
        Rest.create!(attendance:, started_at: attendance.started_at + 2.hours)
        RestFinish.create!(rest: Rest.last, finished_at: Rest.last.started_at + 30.minutes)
        expect(attendance.length).to eq(7.5.hours)
      end
    end

    describe '#state' do
      it 'returns :not_at_work if clock_out exists' do
        attendance = Attendance.create!(work_date: Date.today, started_at: Time.zone.now - 2.hours)
        ClockOut.create!(attendance:, finished_at: attendance.started_at + 8.hours)
        expect(attendance.state).to eq(:not_at_work)
      end

      it 'returns :at_work if no rests or last rest is finished' do
        attendance = Attendance.create!(work_date: Date.today, started_at: Time.zone.now - 2.hours)
        expect(attendance.state).to eq(:at_work)
      end

      it 'returns :on_a_break if last rest is not finished' do
        attendance = Attendance.create!(work_date: Date.today, started_at: Time.zone.now - 2.hours)
        rest = Rest.create!(attendance:, started_at: attendance.started_at + 2.hours)
        expect(attendance.state).to eq(:on_a_break)
      end
    end

    describe '#worked_time_until' do
      it 'calculates worked time until a given end_time' do
        attendance = Attendance.create!(work_date: Date.today, started_at: Time.zone.now - 2.hours)
        end_time = attendance.started_at + 4.hours
        expect(attendance.worked_time_until(end_time)).to eq(4.hours)
      end

      it 'raises an error if clock_out exists' do
        attendance = Attendance.create!(work_date: Date.today, started_at: Time.zone.now - 2.hours)
        ClockOut.create!(attendance:, finished_at: attendance.started_at + 8.hours)
        expect { attendance.worked_time_until(Time.zone.now) }.to raise_error(StandardError)
      end
    end
  end
end
