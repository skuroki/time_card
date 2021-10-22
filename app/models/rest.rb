class Rest < ApplicationRecord
  belongs_to :attendance
  has_one :rest_finish, dependent: :destroy

  def initialize(_)
    super
    self.started_at ||= Time.zone.local(
      attendance.started_at.year,
      attendance.started_at.month,
      attendance.started_at.day,
      Time.zone.now.hour,
      Time.zone.now.min,
      Time.zone.now.sec
    )
  end

  def length
    if rest_finish
      rest_finish.finished_at - self.started_at
    else
      0.minutes
    end
  end
end
