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
