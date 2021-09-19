class Rest < ApplicationRecord
  belongs_to :attendance
  has_one :rest_finish, dependent: :destroy
end
