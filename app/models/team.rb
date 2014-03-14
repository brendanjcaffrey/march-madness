class Team < ActiveRecord::Base
  belongs_to :conference
  has_many :schedule, dependent: :destroy
end
