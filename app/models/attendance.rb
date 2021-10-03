class Attendance < ApplicationRecord
  has_one :clock_out, dependent: :destroy
  has_many :rests, dependent: :destroy

  def work_time
    if clock_out
      a = (clock_out.finished_at - self.started_at)
    else
      nil
    end
  end
end
