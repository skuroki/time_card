class Attendance < ApplicationRecord
  has_one :clock_out
end
