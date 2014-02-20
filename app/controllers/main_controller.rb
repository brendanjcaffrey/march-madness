class MainController < ApplicationController
  def root
    @teams = {1 => 'UIUC', 2 => 'IU'}
  end

  def predict
    render json: {team1: params['team1'], team2: params['team2'], winner: '0'}
  end
end
