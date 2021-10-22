class ClockOut < ApplicationRecord
  belongs_to :attendance

  def initialize(_)
    super
    self.finished_at ||= Time.zone.local(
      attendance.started_at.year,
      attendance.started_at.month,
      attendance.started_at.day,
      Time.zone.now.hour,
      Time.zone.now.min,
      Time.zone.now.sec
    )
  end
end
