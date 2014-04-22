class MainController < ApplicationController
  def root
    @conferences = {}
    Conference.includes(:teams).each do |conf|
      teams = {}
      conf.teams.each { |team| teams[team.id] = team.name }
      @conferences[conf.name] = teams
    end
  end

  def predict
    if Rails.env.production?
      team1 = Team.find_by_id(params['team1'])
      team2 = Team.find_by_id(params['team2'])
      if team1 == nil or team2 == nil
        render :nothing
      else
        $backend.sendTeams([team1.name, team2.name])
        ranking = $backend.getRanking
        winner = ranking.first
        render json: {team1: params['team1'], team2: params['team2'], winner: winner == team1.name ? '1' : '2', debug: ranking}
      end
    else
      render json: {team1: params['team1'], team2: params['team2'], winner: '1'}
    end
  end
end
