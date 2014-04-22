$( document ).ready(function() {
  if ($('#bracket').length == 0) return;

  groups = ['South', 'East', 'West', 'Midwest', 'FF'];
  for (var group_idx in groups) {
    group = $('[data-group=' + groups[group_idx] + ']');
    predict = function(left_rank, right_rank) {
      left = group.find('[data-rank=' + left_rank + ']');
      team1 = left.attr('data-team');
      right = group.find('[data-rank=' + right_rank + ']');
      team2 = right.attr('data-team');

      var result;
      $.ajax({
        type: 'GET',
        async: false,
        url: '/predict/' + team1 + '/' + team2,
        success: function(data) { result = data; }
      });

      var rank = left_rank + 'x' + right_rank;
      var el = group.find('[data-rank=' + rank + ']');
      var team_id, text;
      if (result.winner == '1') {
        team_id = team1;
        text = left.html();
      } else {
        team_id = team2;
        text = right.html();
      }

      el.html(text);
      el.attr('data-team', team_id);
      return rank;
    }

    if (group_idx != 4) {
      rank = predict (
        predict (
          predict( predict('1', '16'), predict('8', '9') ),
          predict( predict('5', '12'), predict('4', '13') )
        ), predict (
          predict( predict('6', '11'), predict('3', '14') ),
          predict( predict('7', '10'), predict('2', '15') )
        )
      );

      // move winner into final four
      var el = group.find('[data-rank=' + rank + ']');
      var el_ff = $('#' + groups[group_idx]);
      el_ff.html(el.html());
      el_ff.attr('data-team', el.attr('data-team'));
    } else {
      predict( predict('s', 'e'), predict('w', 'm') );
    }
  }
});

