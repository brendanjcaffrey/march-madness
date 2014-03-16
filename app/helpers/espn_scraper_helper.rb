require "mechanize"
require "nokogiri"

# Helper functions for Scraping ESPN
module EspnScraperHelper

  # Gets all the teams and all the conferences, puts them in their specified hash
  #	confs - hash for conference -> teams [] 
  #	teams - hash for team -> id
#OLDOLDOLD
  def get_teams
    #Set Up
    TempTeam.delete_all

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


  def get_teams_and_confs()
    Conference.delete_all
    Team.delete_all

    get_confs()

    Conference.find_each do |conf|
puts conf.name
      get_teams_from_conf(conf)
      get_team_scoring_stats(conf)
      get_team_adv_scoring_stats(conf)
      get_team_assists_stats(conf) 
      get_team_rebounds_stats(conf)
      get_team_steals_stats(conf)
      get_team_blocks_stats(conf)
      sleep 3.0
    end
  end

  def get_confs()
    url = "http://espn.go.com/mens-college-basketball/conferences"
    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    list = doc.xpath("//ul[@class='medium-logos']")

    list.css("li").each { |li|
      name = li.css("h5").text
      webExt = doc.at_xpath('//a[text()="'+name+'"]')['href']
      logo = li.at_css("img")['src']
      conf = Conference.create(name: name, webExt: webExt, logo: logo)   
      get_teams_from_conf(conf)
    }
  end

  def get_teams_from_conf(conf)
    #Set Up
    url = "http://espn.com#{conf.webExt}"
    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "mod-data"]')
    rows = table.css('tr')

    rows.each  do |row|
      col = row.css("td")
      if(col.count == 4)
        nameRank = col[0].text.scan((/(#)*(\d+ )*(.*)/))
        name = nameRank[0][2]
        if(nameRank[0][1] != nil)
          rank = nameRank[0][1]
        else
          rank = -1
        end

        webpage = doc.at_xpath('//a[text()="'+name+'"]')['href']
        webExt = webpage.scan(/\d+.*/)[0]

        confWL = col[1].text.scan((/(\d+)-(\d+)/))
        confW = confWL[0][0].to_i
        confL = confWL[0][1].to_i
        
        ovrWL = col[3].text.scan((/(\d+)-(\d+)/))
        ovrW = ovrWL[0][0].to_i
        ovrL = ovrWL[0][1].to_i

        Team.create(name: name, rank: rank, webExt: webExt, conferenceWins: confW, conferenceLosses: confL, wins: ovrW, losses: ovrL, conference: conf)
      #Independents
      elsif(col.count == 3)
        nameRank = col[0].text.scan((/(#)*(\d+ )*(.*)/))
        name = nameRank[0][2]
        if(nameRank[0][1] != nil)
          rank = nameRank[0][1]
        else
          rank = -1
        end

        webpage = doc.at_xpath('//a[text()="'+name+'"]')['href']
        webExt = webpage.scan(/\d+.*/)[0]
        
        ovrWL = col[2].text.scan((/(\d+)-(\d+)/))
        ovrW = ovrWL[0][0].to_i
        ovrL = ovrWL[0][1].to_i

        Team.create(name: name, rank: rank, webExt: webExt, wins: ovrW, losses: ovrL, conference: conf)
      end
    end
  end

  def get_team_scoring_stats(conf)
    #refactor later
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/statistics/team/_/id/#{id[0][1]}/stat/scoring-per-game/" 

    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 10)

        name = col[1].text   

        ppg = col[3].text

        fg = col[4].text.scan((/(\d+.\d+)-(\d+\d+)/))   
        fgm = fg[0][0].to_i
        fga = fg[0][1].to_i
        fgPer = col[5].text

        threeP = col[6].text.scan((/(\d+.\d+)-(\d+.\d+)/))
        threePM = threeP[0][0].to_i
        threePA = threeP[0][1].to_i
        threePer = col[7].text

        twoPM = fgm - threePM
        twoPA = fga - threePA

        ft = col[8].text.scan((/(\d+.\d+)-(\d+.\d+)/))
        ftm = ft[0][0].to_i
        fta = ft[0][1].to_i
        ftPer = col[9].text

        team = Team.find_by! name: name 
        team.update(points: ppg, fgm: fgm, fga: fga, fgPer: fgPer, threeMade: threePM, threeAtt: threePA, threePer: threePer, twoMade: twoPM, twoAtt: twoPA, ftm: ftm, fta: fta, ftPer: ftPer)
      end
    end 
  end

  def get_team_adv_scoring_stats(conf)
    #refactor later
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/statistics/team/_/id/#{id[0][1]}/stat/field-goals/"

    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 14)
        name = col[1].text
        twoPer = col[11].text
        pps = col[12].text
        adjFG = col[13].text

        team = Team.find_by! name: name 
        team.update(twoPer: twoPer, pps: pps, adjFG: adjFG)
      end
    end 
  end

  def get_team_assists_stats(conf)
    #refactor later
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/statistics/team/_/id/#{id[0][1]}/stat/assists/"

    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 8)
        name = col[1].text
        assists = col[4].text
        to = col[6].text
        apto = col[7].text

        team = Team.find_by! name: name 
        team.update(assist: assists, to: to, apto: apto)
      end
    end 
  end

  def get_team_rebounds_stats(conf)
    #refactor later
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/statistics/team/_/id/#{id[0][1]}/stat/rebounds/"

    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 9)
        name = col[1].text
        offReb = col[4].text
        defReb = col[6].text
        totalReb = col[8].text

        team = Team.find_by! name: name 
        team.update(offReb: offReb, defReb: defReb, totalReb: totalReb)
      end
    end 
  end

  def get_team_steals_stats(conf)
    #refactor later
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/statistics/team/_/id/#{id[0][1]}/stat/steals/"

    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 10)
        name = col[1].text
        steals = col[4].text
        fouls = col[7].text.to_f / col[2].text.to_f
        stealPerTO = col[8].text
        stealPerFoul = col[9].text

        team = Team.find_by! name: name 
        team.update(steals: steals, fouls: fouls, stealPerTO: stealPerTO, stealPerFoul: stealPerFoul)
      end
    end 
  end

  def get_team_blocks_stats(conf)
    #refactor later
    id = conf.webExt.scan(/(.*=)(\d+)/)
    url = "http://espn.go.com/mens-college-basketball/conferences/statistics/team/_/id/#{id[0][1]}/stat/blocks/"

    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "tablehead"]')
    rows = table.css('tr[@class != "colhead"]')
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 7)
        name = col[1].text
        blocks = col[5].text
        blocksPerFoul = col[6].text

        team = Team.find_by! name: name 
        team.update(blocks: blocks, blocksPerFoul: blocksPerFoul)
      end
    end 
  end

  # Loops through all teams and calls get_team_schedule
  def get_all_schedules
    Schedule.delete_all

    Team.find_each do |team|
      get_team_schedule(team)
      sleep 15.0
    end
  end

  # Gets a team's schedule and adds to database
  # 	name - team name
  #	id - ESPN id for the team
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
          tScore = scores[0][0].to_i
          oScore = scores[0][1].to_i
        else
          tScore = scores[0][1].to_i
          oScore = scores[0][0].to_i
        end

        Schedule.create(date: date, location: loc, opponent: opp, isWinner: result, teamScore: tScore, oppScore: oScore, team: team)
      end
    end
  end
end
