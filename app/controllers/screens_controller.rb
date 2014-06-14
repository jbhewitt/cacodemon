class ScreensController < ApplicationController
  protect_from_forgery with: :exception

  def index
    screens = Screen.limit(10)
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
  
  def update
  	Rails.logger.debug params.inspect
  	 	#champion = Champion.find_by_name(params['champion'].downcase)

    champion = Champion.find_by_name(/(.*)_0.jpg/.match(params['filename'])[1].downcase)
  	
    screen = Screen.find_or_create_by(id: params['player'])
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
    
    
    mode = Mode.first
    if params['mode'].downcase == "attract"
      mode.state = 0
    else
      mode.state = 1
    end
    mode.save

    render :json => { } # send back any data if necessary
  end
end
