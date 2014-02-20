class Conference < ActiveRecord::Base
  has_many :teams, dependent: :destroy
end
