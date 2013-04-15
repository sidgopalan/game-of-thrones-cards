require "bundler/setup"
require "sinatra/base"
require "sinatra/reloader"
require "json"
require "coffee-script"
require "pinion"
require "pinion/sinatra_helpers"

require_relative "lib/game"

class AppServer < Sinatra::Base
  set :pinion, Pinion::Server.new("/assets")

  configure :development do
    register Sinatra::Reloader
    also_reload "lib/*"
  end

  configure do
    STDOUT.sync = true
    set :show_exceptions, false
    set :dump_errors, false
    error do
      # Show a less fancy error page and stack trace than the default Sinatra one.
      content_type "text/plain"
      error = request.env["sinatra.error"]
      message = error.message + "\n" + error.backtrace.join("\n")
      logger.error message
      message
    end

    # TODO (sid): Store this in Redis if multiple workers are needed
    @@games = {}

    pinion.convert :scss => :css
    pinion.convert :coffee => :js
    pinion.watch "public"

    # In development mode, Sinatra::Reloader reloads the app when files are changed. This causes
    # the pinion create_bundle code to be invoked again. When that happens, Pinion throws an error since the
    # bundle has already been created. Make sure the pinion bundles are only created once
    unless defined?(@@pinion_setup) && @@pinion_setup
      @@pinion_setup = true
      pinion.create_bundle(:app_js, :concatenate_and_uglify_js, [
          "/js/game_selection.js",
          "/js/game.js"
      ])
      pinion.create_bundle(:vendor_js, :concatenate_and_uglify_js, [
          "/vendor/jquery-1.8.2.min.js",
          "/vendor/jquery.mobile-1.3.0.min.js"
      ])
    end
  end

  helpers Pinion::SinatraHelpers

  get "/healthz" do
    "Game of Thrones Cards Reference Server is healthy!"
  end

  post "/games" do
    halt 400, "Missing Parameter: name" unless body_params.has_key?("name")
    game_name = body_params["name"]
    halt 400, "Game name already exists" if @@games.has_key?(game_name)
    @@games[game_name] = Game.new(game_name)
    @@games[game_name].state.to_json
  end

  get "/games" do
    @@games.values.map(&:state).to_json
  end

  before "/games/:game_name/?*" do
    game_name = params[:game_name]
    halt 400, "Game #{game_name} does not exist" unless @@games.has_key?(game_name)
    @game = @@games[game_name]
  end

  get "/games/:game_name" do
    @game.state.to_json
  end

  delete "/games/:game_name" do
    @@games.delete(params[:game_name])
    ""
  end

  post "/games/:game_name/reset" do
    @game.reset
    @game.state.to_json
  end

  before "/games/:game_name/houses/:house_name/?*" do
    house_name = params[:house_name]
    halt 400, "House #{house_name} does not exist" unless House::HOUSE_NAMES.include?(house_name)
    @house = @game.houses[house_name]
  end

  get "/games/:game_name/houses/:house_name" do
    @house.state.to_json
  end

  # Update the card status for a house
  # Expect a json body with format [{ :card_name => "A", :card_status => "used" }]
  put "/games/:game_name/houses/:house_name" do
    body_params.each { |card| @house.update_card_status(card["card_name"], card["card_status"]) }
    @house.state.to_json
  end

  post "/games/:game_name/houses/:house_name/reset" do
    @house.reset
    @house.state.to_json
  end

  get "/" do
    erb :game_selection, :locals => { :games => @@games }
  end

  post "/ui/games" do
    game_name = body_params["name"]
    @@games[game_name] = Game.new(game_name) unless @@games.has_key?(game_name)
    erb :game, :locals => { :game => @@games[game_name] }, :layout => false
  end

  get "/ui/games/:game_name" do
    erb :game, :locals => { :game => @@games[params[:game_name]] }, :layout => false
  end

  get "/ui/games/:game_name/houses/:house_name" do
    game_name = params[:game_name]
    house_name = params[:house_name]
    @game = @@games[game_name]
    @house = @game.houses[house_name]
    erb :house, :locals => { :house => @house, :game => @game }, :layout => false
  end

  def body_params
    if @body_params.nil?
      request.body.rewind
      request_body = request.body.read
      halt 400, "JSON body is required. This request body is blank" if request_body.empty?
      @body_params = JSON.parse(request_body)
      halt 400, "Invalid JSON in the request body." if @body_params.nil?
    end
    @body_params
  end
end
