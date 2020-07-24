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
