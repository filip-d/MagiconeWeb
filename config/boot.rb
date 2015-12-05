ENV["RACK_ENV"] ||= "development"

require 'bundler'
require 'bundler/setup'
Bundler.setup

puts ENV["RACK_ENV"]

Bundler.require(:default, ENV["RACK_ENV"].to_sym)

if (/cygwin|mswin|mingw|bccwin|wince|emx/ =~ RUBY_PLATFORM) != nil
  OS_PLATFORM = :windows
elsif  (/darwin/ =~ RUBY_PLATFORM) != nil
  OS_PLATFORM = :mac
else
  OS_PLATFORM = :linux
end

if OS_PLATFORM == :windows
  FS_ENCODING = Encoding::UTF_16
else
  FS_ENCODING = Encoding::UTF_8
end

module BSON
  class ObjectId
    def to_json(*args)
      to_s.to_json
    end

    def as_json(*args)
      to_s.as_json
    end
  end
end

configure :development do
 require 'sinatra/reloader'
end

Dir["./lib/**/*.rb"].each { |f|
  puts f
  require f
}
Dir["./app/**/*.rb"].each { |f|
  puts f
  require f
}

