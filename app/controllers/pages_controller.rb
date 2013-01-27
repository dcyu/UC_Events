require 'open-uri'
require 'date'

class PagesController < ApplicationController
  def home
    
    access_token = "AAACEdEose0cBAKNb5wADklG15MEYdsDZB4w09tyKf3dogqzYZCZAbZCqJTMwZCiUDq0qr9xGxGe1PQRN04EYlZCH28Yv83lLSl9UmVyl467QZDZD"
    uri = "https://graph.facebook.com/139326516123298?fields=members.fields(events)&access_token=#{access_token}"
    results = JSON.parse(open(uri).read)
    @events = []
    
    results["members"]["data"].each do |r|
      if r["events"]
        r["events"]["data"].each do |d|
          name = d["name"]
          location = d["location"]
          day = day(d["start_time"])
          time = d["start_time"]
          start_time = time(d["start_time"])
          end_time = time(d["end_time"]) if d["end_time"]
          @events << {:name => d["name"], :location => d["location"], :day => day, :time => time, :start_time => start_time, :end_time => end_time}
        end
      end
    end
    
    @events.uniq! {|e| e[:name]}.sort! {|x,y| x[:time] <=> y[:time]}
    
  end
  
  def day(date)
    d = Date.parse(date)
    d.strftime("%A")
  end
  
  def time(date)
    d = Date.parse(date)
    d.strftime("%l:00 %P")
  end
end
