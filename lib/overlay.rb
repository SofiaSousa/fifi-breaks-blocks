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
