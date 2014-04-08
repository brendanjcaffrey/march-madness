class Conference < ActiveRecord::Base
  has_many :teams, -> { order 'name ASC' }, dependent: :destroy
end
