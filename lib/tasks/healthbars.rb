require 'phashion'
require 'RMagick'

require 'phashion'

CHAMP_ICON_SIZE = 45
CHAMP_PROCESS_ICON_SIZE = 45
SIDEBAR_HEIGHT = 3
SIDEBAR_WIDTH = 16
RED_X = 1220
BLUE_X = 27

def check_player_screen(player_number)
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
  return player_number
end

def healthbar_crop_image(source,dest_filename,x_loc,y_loc,height,width)
    t = source.crop(x_loc,y_loc,height,width)#.quantize(16, Magick::GRAYColorspace)
    t.write(dest_filename)    
    return t
end

def healthbar_settings()
  health_choices = Array.new
  health_choices[0] = nil

  health = Hash.new
  health[:name] = 'blue_p1'
  health[:x_loc] =  BLUE_X
  health[:y_loc] =  188
  health_choices << health

  health = Hash.new
  health[:name] = 'blue_p2'
  health[:x_loc] =  BLUE_X
  health[:y_loc] =  258
  health_choices << health

  health = Hash.new
  health[:name] = 'blue_p3'
  health[:x_loc] = BLUE_X
  health[:y_loc] = 327
  health_choices << health

  health = Hash.new
  health[:name] = 'blue_p4'
  health[:x_loc] = BLUE_X
  health[:y_loc] = 397
  health_choices << health

  health = Hash.new
  health[:name] = 'blue_p5'
  health[:x_loc] = BLUE_X
  health[:y_loc] = 466
  health_choices << health


  health = Hash.new
  health[:name] = 'red_p1'
  health[:x_loc] =  RED_X
  health[:y_loc] =  188
  health_choices << health

  health = Hash.new
  health[:name] = 'red_p2'
  health[:x_loc] =  RED_X
  health[:y_loc] =  258
  health_choices << health

  health = Hash.new
  health[:name] = 'red_p3'
  health[:x_loc] =  RED_X
  health[:y_loc] =  327
  health_choices << health

  health = Hash.new
  health[:name] = 'red_p4'
  health[:x_loc] =  RED_X
  health[:y_loc] =  397
  health_choices << health

  health = Hash.new
  health[:name] = 'red_p5'
  health[:x_loc] =  RED_X
  health[:y_loc] =  466
  health_choices << health

  return health_choices
end

class DetectHealthbars
  def initialize()
 
    @healthbar_settings = healthbar_settings()
    system "mkdir /ram_disk/healthbars"
    @player_healthbars = Array.new    
     1.upto(10) do |n|
      @player_healthbars[n] = PlayerHealthbar.new() 
      @player_healthbars[n].number = n
      @player_healthbars[n].xloc = @healthbar_settings[n][:x_loc]
      @player_healthbars[n].yloc = @healthbar_settings[n][:y_loc]
      @player_healthbars[n].height = SIDEBAR_HEIGHT
      @player_healthbars[n].width = SIDEBAR_WIDTH
      @player_healthbars[n].filename = "/ram_disk/healthbars/#{n}.png"
    end
#    self.learn_example_dead     

  end

  def learn_example_dead
    example_png = "tests/example-ingame-dead-p10-p8.tga"
    if USE_RMAGICK 
      example_screen = ImageList.new(example_png)
    elsif
      example_screen = example_png
    end
    crop_image(example_screen, "#{WORKING_DIR}/detect/sidebar_dead_example_grey.png", @healthbar_settings [10][:x_loc], @healthbar_settings [10][:y_loc], SIDEBAR_HEIGHT,SIDEBAR_WIDTH) 
    @dead_example = Phashion::Image.new("#{WORKING_DIR}/detect/sidebar_dead_example_grey.png")
  end

  def screen=(new_screen)
    @screen = new_screen
  end


  def find_health(playerh)    
    player_health = healthbar_crop_image(@screen, playerh.filename, playerh.xloc, playerh.yloc, playerh.height, playerh.width) 

    #puts "player #{playerh.number} colours = #{player_health.number_colors}"
    if player_health.number_colors == 1
      playerh.dead = true
    else
      playerh.dead = false
    end
  end

  def report
#   @player_champions.pry
    report = Array.new
    @player_healthbars.each do |playerh|
#     playerc.pry
      if !playerh.nil?        
        find_health(playerh)
        if playerh.modified?
          changed = Hash.new
          changed[:number] = playerh.number
          changed[:dead] = playerh.dead
          report << changed       
        end
      end
    end
    return report
  end


end

class PlayerHealthbar
  attr_accessor :dead, :number, :xloc, :yloc, :height, :width, :filename
  
  def initialize
    #@number = number     
    @dead = false
    @modified = true

  end

  def dead?
    return @dead
  end

  def dead=(new_status)
    if @dead == new_status
      @modified = false
    else
      @modified = true
      @dead = new_status
    end
  end

  def modified?
    if @modified == true
      @modified = false
      return true
    else
      return false
    end
  end
end

def grab_screen
  #system ("osascript lib/media-capture.scpt")  
  sleep(0.1)
  screencaps = Dir.glob("/screencapture/*.png")
  for screencap in screencaps 
    screen = Magick::Image.read(screencap).first
   system ("rm -f \"#{screencap}\"")
    #puts screencap
  end
  return screen
end
