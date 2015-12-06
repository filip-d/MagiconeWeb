module Magicone

  require 'httparty'

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
      content_type :json
      fakeSoundIndex =  params[:azimuth].to_i / (360/3)
      sound = ["dentist", "waterfall", "sirens"][fakeSoundIndex]
      {:test => sound}.to_json
    end

    get "/resolve/placemap" do
      content_type :json
      puts params[:lat]
      puts params[:lon]
      lat_deg = params[:lat].to_f
      lon_deg = params[:lon].to_f
      resp = ""
      placemap = Placemap.new
      placemap.levels = []
      for levelDistance in [800, 50000, 50000]
        level = Level.new
        level.distance = levelDistance
        level.places = []
        for i in 0..7
          place = Place.new
          #resp = resp + "<br>" + (CoordinatesCalc.offset_coordinate(lat_deg, lon_deg, 1000, 45*i)[0]).to_s
          #resp = resp + ", " + CoordinatesCalc.offset_coordinate(lat_deg, lon_deg, 1000, 45*i)[1].to_s
          coords = CoordinatesCalc.offset_coordinate(lat_deg, lon_deg, levelDistance, 45*i)
          url = "http://geocode.arcgis.com/arcgis/rest/services/World/GeocodeServer/find?location=#{coords[1]},#{coords[0]}&distance=#{levelDistance/4}&maxLocations=1&f=pjson&category=#{categories}&outFields=distance,type"
          puts url
          response = HTTParty.get(url)
          puts JSON.parse(response.parsed_response)["locations"].inspect
          place.description = JSON.parse(response.parsed_response)["locations"][0]["name"]
          place.sound = JSON.parse(response.parsed_response)["locations"][0]["feature"]["attributes"]["type"]
          level.places << place
        end
        placemap.levels << level
      end
      placemap.to_json
    end

    get "/placemap" do
      #File.read(File.join('public', params[:place]+'.json'))
      content_type :json
      File.read(File.join('public', 'london.json'))
    end

    def self.new(*)
      super
    end

    def categories
      [
          "Metro Station",
          "Marina",
          "Dock",
          "Airport",
          "Market",
          "Mosque",
          "Hospital",
          "Fire Station",
          "Farm",
          "Dentist",
          "Church",
          "Tennis Court",
          "Swimming Pool",
          "School",
          "College",
          "Zoo",
          "Casino",
          "Aquarium",
          "Bar or Pub"


      ].join(",")
    end
    
  end
end
