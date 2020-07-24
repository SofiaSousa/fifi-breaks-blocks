require './lib/weapon.rb'

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
