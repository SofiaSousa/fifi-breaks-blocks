
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
