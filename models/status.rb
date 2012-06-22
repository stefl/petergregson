require 'open-uri'

class Status
  include Mongoid::Document
  include Mongoid::Timestamps # adds created_at and updated_at fields

  field :phrase
  field :thing
  field :thing_url
  field :description
  field :happening_at, :type => Date
  field :source
  field :source_url

  def self.get_from_lanyrd
    lanyrd_url = "http://lanyrd.com/profile/#{PeterGregson.lanyrd_user}/future/"
    doc = Nokogiri::HTML(open(lanyrd_url).read)
    items = doc.css(".conference-listing li")
    statuses = []
    items.each do |item|
      puts item
      doing = item.css(".status-indicator").inner_text.strip
      doing = "speaking at" if doing == "speaking"
      thing = item.css("h4 a").inner_text
      thing_url = "http://lanyrd.com" + item.css("h4 a").first['href']
      date = item.css(".dtstart").first['title']
      unless Status.where(:thing_url => thing_url).exists?
        statuses << Status.create( {
          :phrase => doing, 
          :thing => thing, 
          :thing_url => thing_url, 
          :happening_at =>  Date.strptime(date, '%Y-%m-%d'),
          :source => "Lanyrd",
          :source_url => lanyrd_url,
          :description => item.css(".location a").collect {|p| p.inner_text.strip}.reject {|r| r.blank? }.reverse.join(", ")
        } )
      end
    end
    statuses
  end
end
