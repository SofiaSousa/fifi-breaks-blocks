require 'ruby2d'

class Shot
  attr_reader :body

  def initialize(opt = {})
    @x = opt[:x]
    @y = opt[:y]

    @y_speed = 30

    @body = draw
  end

  def draw
    width = 10
    height = 50

    x = @x - (width / 2)
    y = @y - height

    Rectangle.new(
      x: x,
      y: y,
      width: 10,
      height: 50,
      color: 'lime'
    )
  end

  def fly
    @body.y -= @y_speed

    if @body.y > Window.height
      @body.remove
    end
  end

  def hit(block)
    @body.remove
    block.damage
  end
end

class Weapon
  def initialize; end

  def shoot(x, y)
    Shot.new(x: x, y: y)
  end
end

class Hero
  attr_reader :shots

  def initialize
    @width = 150
    @height = 25
    @x_speed = 10

    @body = draw
    @weapon = Weapon.new
    @shots = []
  end

  def draw
    x = (Window.width / 2) - (@width / 2)
    y = Window.height - @height

    Rectangle.new(
      x: x, y: y,
      width: @width, height: @height,
      color: 'teal',
      z: 20
    )
  end

  def move(direction)
    if direction == 'left' && @body.x > -( @width / 2 )
      @body.x -= @x_speed
    elsif direction == 'right' && @body.x < Window.width - (@body.width / 2)
      @body.x += @x_speed
    end
  end

  def shoot
    x = @body.x + (@width / 2)
    y = @body.y

    @shots << @weapon.shoot(x, y)
  end

  def moving
    @body.x += @x_speed
  end
end
class Block
  attr_reader :body, :status

  COLORS = ['yellow', 'orange', 'red']

  def initialize(opt = {})
    @x = opt[:x]
    @y = opt[:y]
    @size = opt[:size]

    @status = rand(3)

    @body = draw
  end

  def draw
    Square.new(
      x: @x, y: @y,
      size: @size,
      color: COLORS[@status]
    )
  end

  def go_down
    @y += 1
    @body.y = @y * (@size + 1)
  end

  def collision_detected?(shot)
    @body.contains?(shot.body.x1, shot.body.y1) ||
    @body.contains?(shot.body.x2, shot.body.y2)
  end

  def damage
    @status -= 1

    if is_detroyed?
      @body.remove
    else
      @body.color = COLORS[@status]
    end
  end

  def is_detroyed?
    @status < 0
  end
end

class Line
  attr_reader :blocks

  N_ITEMS = 10

  def initialize(opt = {})
    y = opt[:y]
    size = (Window.width / N_ITEMS)

    @blocks = []

    N_ITEMS.times do |x|
     @blocks << Block.new(
        x: x * (size + 1),
        y: y * (size + 1),
        size: size - 1,
      )
    end
  end
end

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
