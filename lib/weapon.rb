require './lib/shot.rb'

class Weapon
  def initialize; end

  def shoot(x, y)
    Shot.new(x: x, y: y)
  end
end
