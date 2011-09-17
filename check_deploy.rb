#!/usr/bin/env ruby
require 'curb'
require 'json'
require 'open-uri'

REPO = "charliesome/rnews"

status = JSON.parse(open("http://travis-ci.org/#{REPO}.json").read)
if status["last_build_status"] == 0
  # successful build
  build = JSON.parse(open("http://travis-ci.org/#{REPO}/builds/#{status["last_build_id"]}.json").read)
  
  puts "Deploying to #{build["commit"]}... "
  
  output = `git fetch && git merge #{build["commit"]}`
  
  unless output.include? "Already up-to-date"
    fork do
      $stdout = File.open("/dev/null", "w")
      system("rake test")
      exit!
    end
    
    system("touch tmp/restart.txt")
    puts "Restarted app"
  end
  
  puts "Ok."
end