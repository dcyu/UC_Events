require 'open-uri'
require 'date'
require 'time'


class PagesController < ApplicationController
  def home
    
    access_token = "AAACEdEose0cBADl18geCDPVQzqfWHkgK9URrZBJN4qNDtBZA5pyxzouR4VRu8oZCzsfOrnECDCX6SSlOjevPJta9B9QSCPaLMjnBIuGlQZDZD"
    uri = "https://graph.facebook.com/139326516123298?fields=members.fields(events)&access_token=#{access_token}"
    results = JSON.parse(open(uri).read)
    @events = []
    
    results["members"]["data"].each do |r|
      if r["events"]
        r["events"]["data"].each do |d|
          name = d["name"]
          location = d["location"]
          day = day(d["start_time"])
          time = d["start_time"].to_datetime
          start_time = time(d["start_time"])
          end_time = time(d["end_time"]) if d["end_time"]
          @events << {:id => d["id"], :name => d["name"], :location => d["location"], :day => day, :time => time, :start_time => start_time, :end_time => end_time}
        end
      end
    end
    
    @events.uniq! {|e| e[:name]}.sort! {|x,y| x[:time] <=> y[:time]}.select! {|s| s[:time] > Time.now}
    
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
