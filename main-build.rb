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

# The game hero
class Hero
  attr_reader :body, :shots

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
# A block object to destroy that can have one of these 3 colors:
# - yellow : 1 shot to destroy
# - orange : 2 shots to destroy
# - red    : 3 shots to destroy
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

# A raw of blocks
class Raw
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

# The limit until blocks can go down before game over.
class Limit
  attr_reader :body

  def initialize(opt = {})
    @body = draw
  end

  def draw
    y = Window.height - 170
    Line.new(
      x1: 0, y1: y,
      x2: Window.width, y2: y,
      width: 1,
      color: 'silver',
      z: 20
    )
  end
end
class Overlay
  def initialize(opt = {})
    @body = draw
    @text_body = draw_text(opt[:text])
    center_text
    hide # hidden by defautl
  end

  def draw
    rect = Rectangle.new(
      x: 0,
      y: 0,
      width: Window.width,
      height: Window.height,
      color: 'silver',
      z: 100
    )

    rect.opacity = 0.5
    rect
  end

  def draw_text(text)
    text = text || ''
    Text.new(
      text,
      size: 60,
      color: 'red',
      z: 100
    )
  end

  def show
    @body.add
    @text_body.add
  end

  def hide
    @body.remove
    @text_body.remove
  end

  def text=(new_text)
    @text_body.text = new_text
    center_text
  end

  private

  def center_text
    @text_body.x = (Window.width / 2) - (@text_body.width / 2)
    @text_body.y = (Window.height / 2) - (@text_body.height / 2)
  end
end

# World settings
set title: 'Fifi Breaks Blocks!',
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
gover_overlay = Overlay.new(text: '- GAME OVER -')
pause_overlay = Overlay.new(text: '- PAUSED -')
score = 0
score_bar = Text.new(
  score,
  color:
  'white',
  x: 20, y: Window.height - 25,
  z: 20
)

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
    # gover_overlay.text = "GAME OVER - #{score}"
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
          score += 10
          score_bar.text = score

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
