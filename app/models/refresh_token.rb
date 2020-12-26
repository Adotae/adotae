class RefreshToken < ApplicationRecord
  belongs_to :user
  belongs_to :admin_user
end
