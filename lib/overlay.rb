class Overlay
  def initialize(opt = {})
    @body = draw
    @text_body = draw_text(opt[:text])

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
    t = Text.new(
      text,
      size: 60,
      color: 'red',
      z: 100
    )

    t.x = (Window.width / 2) - (t.width / 2)
    t.y = (Window.height / 2) - (t.height / 2)

    t
  end

  def show
    @body.add
    @text_body.add
  end

  def hide
    @body.remove
    @text_body.remove
  end
end
