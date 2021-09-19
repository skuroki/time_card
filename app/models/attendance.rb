class Attendance < ApplicationRecord
  has_one :clock_out, dependent: :destroy
  has_many :rests, dependent: :destroy
end
