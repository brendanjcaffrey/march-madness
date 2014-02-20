$( document ).ready(function() {
  loading = false;

  $('#teams').submit(function(e) {
    e.preventDefault();
    if (loading) return;

    team1 = $('#team1 option:selected')[0].id;
    team1_name = $('#team1 option:selected').text();
    team2 = $('#team2 option:selected')[0].id;
    team2_name = $('#team2 option:selected').text();
    if (team1 == team2) {
      alert('must select different teams');
      return;
    }

    loading = true;
    $.ajax({
      url: '/predict/' + team1 + '/' + team2
    }).done(function(data) {
      if (data.winner == '0') {
        alert('Predicted winner: ' + team1_name);
      } else {
        alert('Predicted winner: ' + team2_name);
      }

      loading = false;
    });
  });
});


