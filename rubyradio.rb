#!/usr/bin/env ruby
# hachiya@tut0r.com
require 'rubygems'
require 'mechanize'

stations=[
  ["Republic Broadcasting", "http://www.republicbroadcasting.org/32k.asx"],
  ["KFI 640", "http://kfi640.com/cc-common/ondemand/player.html?world=st", 1],
  ["WISN", "http://www.newstalk1130.com/cc-common/ondemand/player.html", 1],
  ["FM 106", "http://fm106.com/cc-common/ondemand/player.html?world=st", 1],
  ["KISS", "http://www.1023kissfm.com/cc-common/ondemand/player.html?world=st&stream_id=1421", 1],
  ["Alternative Rock", "http://www.channel1031.com/cc-common/ondemand/player.html?world=st&stream_id=1417", 1],
]


def compute_url(url)
  page=@agent.get url

  host=URI.parse(url).host

  token=page.body.match(/streaming_token = '(.*?)'/)[1]
  puts token

  site_id=page.body.match(/site_id = '(.*?)'/)[1]
  puts site_id 

  modified_token=token[1..-1]
  puts modified_token


  # TODO - if the URL below changes, can first pull player.js and lookfor
  # ;new Ajax.Request('/cc-common/universal_player/services/1_4_1_4/getstationlist2.php?dontcacheme=1',{
  
  url=URI.join("http://#{host}", "/cc-common/universal_player/services/1_4_1_4/getstationlist2.php?dontcacheme=1&site_id=#{site_id}")

  page=@agent.get url

  stream_id=page.body.match(/"stream_id" : (\d+)/)[1]
  puts stream_id
  url4=URI.join("http://#{host}", "/cc-common/universal_player/services/genasx.php?ua=#{modified_token}&id=#{stream_id}")

  puts "STREAM URL: #{url4}"
  url4
end



def compute_url_old(url, id)
  page=@agent.get url

  host=URI.parse(url).host

  token=page.body.match(/streaming_token = '(.*?)'/)[1]
  puts token

  modified_token=token[1..-1]
  puts modified_token
  url4=URI.join("http://#{host}", "/cc-common/universal_player/services/genasx.php?ua=#{modified_token}&id=#{id}")

  puts "STREAM URL: #{url4}"
  url4
end


@agent=WWW::Mechanize.new 

stations.each_with_index do | station, i |
  puts "#{i}) #{station[0]}"
end

station=stations[STDIN.gets.to_i]

puts station[1]


if station[2]==1
  url=compute_url(station[1])
else
  url=station[1]
end

puts url
cmd="mplayer -quiet -playlist \"#{url}\""

pid=system(cmd)
puts "pid: #{pid}"
while true
end


