class BlacklistedToken < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :admin_user, optional: true
end
