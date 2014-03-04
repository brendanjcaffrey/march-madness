class TempTeam < ActiveRecord::Base
  has_many :schedule, dependent: :destroy
end
