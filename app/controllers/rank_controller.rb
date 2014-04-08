class RankController < ApplicationController
  def root
    @teams = Team.all
  end
end
