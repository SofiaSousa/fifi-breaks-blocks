require 'ruby2d'

require './lib/hero.rb'
require './lib/raw.rb'

# World settings
set title: 'Fifi is in the house',
    background: 'navy',
    width: 640,
    height: 960,
    resizable: false

# Init
start_time = Time.now

hero = Hero.new
blocks = []
blocks += Raw.new(y: 0).blocks
blocks.each do |block|
  block.go_down
end
blocks += Raw.new(y: 0).blocks

# Events
on :key_down do |event|
  close if event.key == 'escape'
  hero.shoot if event.key == 'space'
end

on :key_held do |event|
  hero.move(event.key) if event.key == 'left' || event.key == 'right'
end

# Loop
update do
  if ((Time.now - start_time) * 1000) > 5000
    # New line of blocks
    blocks.each do |block|
      block.go_down
    end

    blocks += Raw.new(y: 0).blocks

    start_time = Time.now
  end

  # Shots
  hero.shots.each do |shot|
    # Blocks
    blocks.each do |block|
      if block.collision_detected?(shot)
        shot.hit(block)

        hero.shots.delete(shot)
        blocks.delete(block) if block.is_detroyed?
        break
      end
    end

    shot.fly
  end
end

# Render
show
