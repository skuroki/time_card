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
end
