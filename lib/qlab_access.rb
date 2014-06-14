require 'qlab-ruby'

class OutputScreen
  MACHINE = QLab.connect configatron.qlab.ip, configatron.qlab.port # defaults to ('localhost', 53000)
  QLAB = MACHINE.workspaces.first

  def initialize
  end

  def dead_player(player_number)    
    QLAB.cues[player_number].doEffect = true
  end

  def alive_player(player_number)
    QLAB.cues[player_number].doEffect = false
  end

  def fadeout_player(player_number)
    amount = 1
    while amount > 0 do
      amount = amount - 0.05
      QLAB.cues[player_number].opacity = amount
      sleep 0.05
    end 
    QLAB.cues[player_number].stop
  end

  def fadein_player(player_number)
    amount = 0
    QLAB.cues[player_number].start
    while amount < 1.05  do
      amount = amount + 0.05
      QLAB.cues[player_number].opacity = amount
      sleep 0.1
    end 
  end

  def change_player(splash_jpg, player_number, how_long=1)
    filetarget = "#{configatron.qlab.sourcefiles}/#{splash_jpg}"
    puts "Changing #{player_number} TO #{filetarget}"
    self.fadeout_player(player_number)    
    QLAB.cues[player_number].fileTarget = filetarget
    sleep 0.1
    self.fadein_player(player_number)
    self.pause(player_number)
    #sleep 4
  # QLAB.cues[player_number].pause
  end

  def start ( player_number )
    QLAB.cues[player_number].start
  end
 
  def stop ( player_number )
    QLAB.cues[player_number].stop
  end

  def pause ( player_number )
    QLAB.cues[player_number].pause
  end
end
