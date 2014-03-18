require "mechanize"
require "nokogiri"

# Helper functions for Scraping ESPN
module EspnScraperHelper

  def get_teams()
    Conference.delete_all
    Team.delete_all

    get_confs()

    Conference.find_each do |conf|
      get_teams_from_conf(conf)
      sleep 2.0
      get_team_scoring_stats(conf)
      sleep 2.0
      get_team_adv_scoring_stats(conf)
      sleep 2.0
      get_team_assists_stats(conf) 
      sleep 2.0
      get_team_rebounds_stats(conf)
      sleep 2.0
      get_team_steals_stats(conf)
      sleep 2.0
      get_team_blocks_stats(conf)
      sleep 10.0
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

  def get_games
    Game.delete_all
    Team.find_each do |team|
      puts team.name
      get_team_games(team)
      sleep 10.0
    end
  end

  def get_team_games(team)
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
        linkHref = row.css('li[@class ="score"]')[0].css('a[href]')[0]
        if(linkHref != nil)
          link = linkHref["href"].scan(/(.*=)(\d+)/)
          gameID = link[0][1] 
          if(Game.where(gameID: gameID).empty?)
            #get Date
            date = row.css("td")[0].text
            #get opp
            opp = row.css('li[@class ="team-name"]').text
            #get HOME/away (vs/@)
            loc = row.css('li[@class ="game-status"]').text
            if(loc == "@")
              homeTeam = team.name
              awayTeam = opp
            else
              homeTeam = opp
              awayTeam = team.name
            end
            game = Game.create(gameID: gameID, date: date, homeTeam: homeTeam, awayTeam: awayTeam)
            get_game_stats(game)

            sleep 5.0
          end
        end
      end
    end
  end

  def get_game_stats(game)
    url = "http://espn.go.com/ncb/boxscore?gameId=#{game.gameID}"
    agent = Mechanize.new
    html = agent.get(url).body
    doc = Nokogiri::HTML(html)

    table = doc.xpath('//table[@class = "mod-data"]')
    rows = table.css('tbody')
    isHome = false
    homePoints = 0
    awayPoints = 0
    rows.each  do |row|
      col = row.css('td')
      if(col.count == 18)
        fg = col[1].text.scan((/(\d+)-(\d+)/))   
        fgm = fg[0][0].to_f
        fga = fg[0][1].to_f
        fgPer = fgm / fga

        threeP = col[2].text.scan((/(\d+)-(\d+)/))
        threePM = threeP[0][0].to_f
        threePA = threeP[0][1].to_f
        threePer = threePM / threePA

        twoPM = fgm - threePM
        twoPA = fga - threePA
        twoPer = twoPM.to_f / twoPA.to_f

        ft = col[3].text.scan((/(\d+)-(\d+)/))
        ftm = ft[0][0].to_f
        fta = ft[0][1].to_f
        ftPer = ftm / fta

        offReb = col[4].text.to_f
        defReb = col[5].text.to_f
        totReb = col[6].text.to_f
        assists = col[7].text.to_f
        steals = col[8].text.to_f
        blocks = col[9].text.to_f
        to = col[10].text.to_f
        pf = col[11].text.to_f

        points = col[12].text.to_f
        pps = points / fga
        adjFG = ((points - ftm)/ fga)/ 2

        apto = assists / to
        spto = steals / to
        spf = steals / pf
        bpf = blocks / pf
  

        if(isHome)
          game.update(homePoints: points, homefgm: fgm, homefga: fga, homefgPer: fgPer, hometwoMade: twoPM, hometwoAtt: twoPA, hometwoPer: twoPer, homethreeMade: threePM, homethreeAtt: threePA, homethreePer: threePer, homeftm: ftm, homefta: fta, homeftPer: ftPer, homeoffReb: offReb, homedefReb: defReb, hometotalReb: totReb, homepps: pps, homeadjFG: adjFG, homeassist: assists, hometo: to, homeapto: apto, homesteals: steals, homefouls: pf, homestealPerTO: spto, homestealPerFoul: spf, homeblocks: blocks, homeblocksPerFoul: bpf)
        elsif
          game.update(awaypoints: points, awayfgm: fgm, awayfga: fga, awayfgPer: fgPer, awaytwoMade: twoPM, awaytwoAtt: twoPA, awaytwoPer: twoPer, awaythreeMade: threePM, awaythreeAtt: threePA, awaythreePer: threePer, awayftm: ftm, awayfta: fta, awayftPer: ftPer, awayoffReb: offReb, awaydefReb: defReb, awaytotalReb: totReb, awaypps: pps, awayadjFG: adjFG, awayassist: assists, awayto: to, awayapto: apto, awaysteals: steals, awayfouls: pf, awaystealPerTO: spto, awaystealPerFoul: spf, awayblocks: blocks, awayblocksPerFoul: bpf)
        end

        isHome = true
      end
    end  
  end
end
