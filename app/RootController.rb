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

    def self.new(*)
      super
    end
    
  end
end
