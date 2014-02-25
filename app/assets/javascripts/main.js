$( document ).ready(function() {
  loading = false;

  reset_prediction = function(e) {
    $('#prediction').text('');
    $('#prediction').removeClass('error');
  }

  $('#team1').change(reset_prediction);
  $('#team2').change(reset_prediction);

  $('#teams').submit(function(e) {
    e.preventDefault();
    if (loading) return;

    team1 = $('#team1 option:selected')[0].id;
    team1_name = $('#team1 option:selected').text();
    team2 = $('#team2 option:selected')[0].id;
    team2_name = $('#team2 option:selected').text();
    if (team1 == team2) {
      $('#prediction').text('You must select different teams!')
      $('#prediction').addClass('error')
      return;
    }

    loading = true;
    $.ajax({
      url: '/predict/' + team1 + '/' + team2
    }).done(function(data) {
      winner_text = 'Predicted winner: '
      if (data.winner == '0') {
        winner_text += team1_name;
      } else {
        winner_text += team2_name;
      }

      $('#prediction').text(winner_text);
      loading = false;
    });
  });
});


