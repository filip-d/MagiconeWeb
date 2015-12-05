module Magicone

  class RootController < Sinatra::Base
    
    #configure do
      # set app specific settings
      # for example different view folders
    #end

    configure :development do
      register Sinatra::Reloader
      #  also_reload 'lib/model/quiz.rb'
      Dir["./lib/**/*.rb"].each { |f|
        puts "Reload: #{f}"
        also_reload f
      }
    end

    get "/" do
      erb :index
    end

    get "/resolve" do
      fakeSoundIndex =  params[:azimuth].to_i / (360/3)
      sound = ["dentist", "waterfall", "sirens"][fakeSoundIndex]
      {:test => sound}.to_json
    end

    def self.new(*)
      super
    end
    
  end
end
