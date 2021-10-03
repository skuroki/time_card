class Attendance < ApplicationRecord
  has_one :clock_out, dependent: :destroy
  has_many :rests, dependent: :destroy

  def length
    if clock_out
      (clock_out.finished_at - self.started_at) - rests.map(&:length).sum
    else
      0.minutes
    end
  end
end
