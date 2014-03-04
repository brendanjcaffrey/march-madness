require "mechanize"
require "nokogiri"

module EspnScraperHelper
  # Gets all the teams and all the conferences, puts them in their specified hash
  #	confs - hash for conference -> teams [] 
  #	teams - hash for team -> id
  # TODO: Fill the conference arrays
  def get_teams
    #Set Up
    url = "http://espn.go.com/mens-college-basketball/teams"
    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    #Get Conferences
    confs_html = doc.xpath("//div[@class='mod-header colhead']")
    confs_html.each { |c| 
      #c.txt is conference name
    }

    #Get Teams
    teams_html = doc.xpath("//h5")
    teams_html.each { |t| 
      name = t.text
      webpage = doc.at_xpath('//a[text()="'+name+'"]')["href"]
      ext = webpage.scan(/\d+.*/)[0]

      TempTeam.create(name: name, webExt: ext)
    }
  end


  # Gets a team's schedule and creates a file for the the team in a specified format
  # 	name - team name
  #	id - ESPN id for the team
  #TODO:make classes, make tests, find proper way to output, ensure file pointer is closed
  def get_team_schedule (team)
    #Set Up
    url = "http://espn.go.com/mens-college-basketball/team/schedule/_/id/#{team.webExt}"
    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)
    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr')

    #Loop through each row
    rows.each  do |row|
      if(row.css('li').count > 3)
        #get Date
        date = row.css("td")[0].text

        #get HOME/away (vs/@)
        loc = row.css('li[@class ="game-status"]').text

        #get opp
        opp = row.css('li[@class ="team-name"]').text

        #get win / loss
        result = false
        win = row.css('li[@class ="game-status win"]').text 
        if(!win.empty?)
          result = true
        end
        #maybe check for false???
        #loss = row.css('li[@class ="game-status loss"]').text 

        #get score
        scores = row.css('li[@class ="score"]').text.scan((/(\d+)-(\d+)/))
        tScore = 0
        oScore = 0
        if(result)
          tScore = scores[0].to_i
          oScore = scores[1].to_i
        else
          tmScore = scores[1].to_i
          oScore = scores[0].to_i
        end

        Schedule.create(date: date, location: loc, opponent: opp, isWinner: result, teamScore: tScore, oppScore: oScore, temp_team: team)
      end
    end
    sleep 15.0
  end
end
