require_relative "house"

class Game
  attr_reader :name, :houses

  def initialize(name)
    @name = name
    @houses = {}
    House::HOUSE_NAMES.each { |house_name| @houses[house_name] = House.new(house_name) }
  end

  def state
    game_state = { :name => @name, :houses => {} }
    @houses.each { |house_name, house| game_state[:houses][house_name] = house.state }
    game_state
  end

  def reset
    @houses.each(&:reset)
  end
end