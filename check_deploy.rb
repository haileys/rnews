#!/usr/bin/env ruby
require 'curb'
require 'json'
require 'open-uri'

REPO = "charliesome/rnews"

status = JSON.parse(open("http://travis-ci.org/#{REPO}.json").read)
if status["last_build_status"] == 0
  # successful build
  build = JSON.parse(open("http://travis-ci.org/#{REPO}/builds/#{status["last_build_id"]}.json").read)
  
  print "Deploying to #{build["commit"]}... "
  
  system("rake test &> /dev/null &")
  system("git fetch && git merge #{build["commit"]} && touch tmp/restart.txt")
  
  puts "ok."
end