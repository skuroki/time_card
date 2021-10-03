class Rest < ApplicationRecord
  belongs_to :attendance
  has_one :rest_finish, dependent: :destroy

  def length
    if rest_finish
      rest_finish.finished_at - self.started_at
    else
      0.minutes
    end
  end
end
