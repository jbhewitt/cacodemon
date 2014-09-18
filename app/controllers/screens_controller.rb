class ScreensController < ApplicationController
  protect_from_forgery with: :exception

  def index
    screens = Screen.limit(10).order("id")
    i = 1
    @screen = Array.new
    screens.each { |s| 
      if s.champion.nil?
        @screen[i] = 'blank'
      else
        @screen[i] = s.champion.name      
      end
      i = i + 1
    }
    
    gon.watch.screen = @screen
  end
  
  def current
    screens = Screen.limit(10).order("id")
    i = 1
    @screen = Array.new
    screens.each { |s| 
      if s.champion.nil?
        @screen[i] = 'blank'
      else
        @screen[i] = s.champion.name      
      end
      i = i + 1
    }
    
    #gon.watch.screen = @screen
  end



  def update
  	#Rails.logger.debug params.inspect
  	 	#champion = Champion.find_by_name(params['champion'].downcase)
    champion = Champion.find_by_name(/(.*)_0.jpg/.match(params['filename'])[1].downcase)

    player_number = params['player'].to_i

    teams_swapped = Mode.find_by_name("teams-swapped").state
    if teams_swapped == 1
      if player_number == 1
        player_number = 6
      elsif player_number == 2
        player_number = 7
      elsif player_number == 3
        player_number = 8
      elsif player_number == 4
        player_number = 9
      elsif player_number == 5
        player_number = 10
      elsif player_number == 6
        player_number = 1
      elsif player_number == 7
        player_number = 2
      elsif player_number == 8
        player_number = 3
      elsif player_number == 9
        player_number = 4
      elsif player_number == 10
        player_number = 5
      end   
    end

  	
    screen = Screen.find_or_create_by(id: player_number)
  	screen.champion = champion
    screen.splash = champion.splashes[0]
  	screen.save

    job = Jobqueue.new
    job.screen = screen
    job.save

    render :json => { } # send back any data if necessary
  end

  def update_mode    
    #champion = Champion.find_by_name(params['champion'].downcase)      
    
    selected_mode = params['mode'].downcase 
    if selected_mode  == "attract"
      mode = Mode.find_by_name("attract-tournament") 
      mode.state = 0
    elsif selected_mode  == "tournament"
      mode = Mode.find_by_name("attract-tournament")
      mode.state = 1
    elsif selected_mode == "swap-teams"
      mode = Mode.find_by_name("teams-swapped")
      if mode.state == 0 
        mode.state = 1
      else
        mode.state = 0
      end      
    end
    mode.save

    render :json => { } # send back any data if necessary
  end


end
