class Attendance < ApplicationRecord
  has_one :clock_out, dependent: :destroy
  has_many :rests, dependent: :destroy

  before_save do
    self.started_at &&= Time.zone.local(
      work_date.year,
      work_date.month,
      work_date.day,
      started_at.hour,
      started_at.min,
      started_at.sec
    )
  end

  def length
    if clock_out
      (clock_out.finished_at - self.started_at) - rests.map(&:length).sum
    else
      0.minutes
    end
  end

  def state
    if clock_out
      :not_at_work
    else
      last_rest = rests.last
      if last_rest.nil? || last_rest.rest_finish
        :at_work
      else
        :on_a_break
      end
    end
  end

  def worked_time_until(end_time)
    raise '勤務が既に終了しています' if clock_out

    total_worked_time = end_time - started_at

    rests.each do |rest|
      rest_end = rest.rest_finish&.finished_at || end_time
      rest_duration = [rest_end, end_time].min - rest.started_at
      total_worked_time -= rest_duration
    end

    total_worked_time
  end
end
