require "bundler/setup"
require "sinatra/base"
require "sinatra/reloader"
require "json"
require "coffee-script"

class AppServer < Sinatra::Base
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
  end

  get "/healthz" do
    "Game of Thrones Cards Reference Server is healthy!"
  end
end
