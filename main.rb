require 'ruby2d'

require './lib/hero.rb'
require './lib/line.rb'

set title: 'Fifi is in the house',
    background: 'navy',
    width: 640,
    height: 640, # 1280,
    resizable: false

start_time = Time.now

hero = Hero.new
blocks = []
blocks += Line.new(y: 0).blocks
blocks.each do |block|
  block.go_down
end
blocks += Line.new(y: 0).blocks

on :key_down do |event|
  if event.key == 'escape'
    close
  end

  if event.key == 'space'
    hero.shoot
  end
end

on :key_held do |event|
  if event.key == 'left' || event.key == 'right'
    hero.move(event.key)
  end
end

update do
  if ((Time.now - start_time) * 1000) > 5000
    # New line of blocks
    blocks.each do |block|
      block.go_down
    end

    blocks += Line.new(y: 0).blocks

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

show
