class Attendance < ApplicationRecord
  has_one :clock_out
  has_many :rests
end
