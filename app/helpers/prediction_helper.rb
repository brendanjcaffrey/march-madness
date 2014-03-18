class PredictionHelper
  def self.get_prediction(team1_id, team2_id)
    $prediction_engine.send(team1_id.to_s + "\r\n" + team2_id.to_s)
    $prediciton_engine.gets
  end
end
