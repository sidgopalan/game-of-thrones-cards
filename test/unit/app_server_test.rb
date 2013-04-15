require "minitest/autorun"
require "scope"
require "rack/test"
require_relative "../../app_server"

class AppServerTest < Scope::TestCase
  include Rack::Test::Methods

  def json_response
    JSON.parse(last_response.body)
  end

  def app
    @app ||= AppServer.new!
  end


  context "New Game" do
    should "create a new game" do
      post "/games", { "name" => "test_game" }.to_json
      assert_equal "test_game", json_response["name"]
      assert_equal House::HOUSE_NAMES, json_response["houses"].map { |name, _| name }
    end
  end

  context "Existing Game" do
    setup do
      post "/games", { "name" => "test_game" }.to_json
    end

    should "get existing games" do
      get "/games"
      assert_equal 1, json_response.size
      assert_equal "test_game", json_response[0]["name"]
    end

    should "get specific game" do
      get "/games/test_game"
      assert_equal "test_game", json_response["name"]
      assert_equal House::HOUSE_NAMES, json_response["houses"].map { |name, _| name }
    end
  end

end