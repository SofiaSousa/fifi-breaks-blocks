require './lib/block.rb'

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
