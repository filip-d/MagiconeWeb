require File.dirname(__FILE__) + '/config/boot.rb'

base = File.dirname(__FILE__)
$:.unshift File.join(base, "lib")
Sinatra::Base.set(:root) { base }

run Rack::URLMap.new({
                         "/"    => Magicone::RootController
                     })

