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
    render json: {team1: params['team1'], team2: params['team2'], winner: '0'}
  end
end
