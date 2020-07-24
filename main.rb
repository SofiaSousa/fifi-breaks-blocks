require 'ruby2d'

require './lib/hero.rb'
require './lib/raw.rb'
require './lib/limit.rb'
require './lib/overlay.rb'

# World settings
set title: 'Sofs Breaks Blocks!',
    background: 'navy',
    width: 640,
    height: 960,
    resizable: false

# Init
is_game_over = false
is_paused    = false
start_time = Time.now

hero = Hero.new
limit = Limit.new
gover_overlay = Overlay.new(text: 'GAME OVER')
pause_overlay = Overlay.new(text: 'PAUSED')

# Add initial blocks
blocks = []
blocks += Raw.new(y: 0).blocks
blocks.each do |block|
  block.go_down
end
blocks += Raw.new(y: 0).blocks

# Events
on :key_down do |event|
  close if event.key == 'escape'

  unless is_game_over
    is_paused = ! is_paused if event.key == 'p'
    hero.shoot if ! is_paused && event.key == 'space'
  end
end

on :key_held do |event|
  hero.move(event.key) if event.key == 'left' || event.key == 'right'
end

# Loop
update do
  if is_game_over
    gover_overlay.show
  elsif is_paused
    pause_overlay.show
    start_time = Time.now
  else
    pause_overlay.hide

    if ((Time.now - start_time) * 1000) > 5000
      # New line of blocks
      blocks.each do |block|
        block.go_down
      end

      blocks += Raw.new(y: 0).blocks

      start_time = Time.now
    end

    blocks.each do |block|
      if block.collision_detected?(limit)
        is_game_over = true
        hero.body.remove
      end

      hero.shots.each do |shot|
        if block.collision_detected?(shot)
          shot.hit(block)

          hero.shots.delete(shot)
          blocks.delete(block) if block.is_detroyed?
          break
        end
      end
    end

    # Shots
    hero.shots.each do |shot|
      shot.fly
    end
  end
end

# Render
show
