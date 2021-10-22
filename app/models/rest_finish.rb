class RestFinish < ApplicationRecord
  belongs_to :rest

  def initialize(_)
    super
    self.finished_at ||= Time.zone.local(
      rest.started_at.year,
      rest.started_at.month,
      rest.started_at.day,
      Time.zone.now.hour,
      Time.zone.now.min,
      Time.zone.now.sec
    )
  end
end
