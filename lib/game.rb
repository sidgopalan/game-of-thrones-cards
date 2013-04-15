require_relative "house"

class Game
  attr_reader :name, :houses

  def initialize(name)
    @name = name
    @houses = {}
    House::HOUSE_NAMES.each { |house_name| @houses[house_name] = House.new(house_name) }
  end

  def to_json
    { :name => @name, :houses => @houses }.to_json
  end

  def reset
    @houses.each(&:reset)
  end
end