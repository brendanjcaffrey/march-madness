class RankController < ApplicationController
  def root
    if Rails.env.production?
      $backend.sendTeams(['rank'])
      ranks = $backend.getRanking
      @teams = ranks.map { |team| Team.where(name: team).first }
    else
      @teams = Team.all
    end
  end
end
