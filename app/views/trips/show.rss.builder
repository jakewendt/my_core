xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0", "xmlns:atom" =>"http://www.w3.org/2005/Atom" ){
  xml.channel{
    xml.title(@trip.title)
    xml.description(@trip.description)
    xml.link(trip_url(@trip, :format => :rss))
    xml.language('en-us')
# feedvalidator.org
# recommended to add something like ...
# <atom:link href="http://dallas.example.com/rss.xml" rel="self" type="application/rss+xml" />
# but I don't know exactly how to do that
      for stop in @trip.stops
        xml.item do
          xml.title(stop.title)
          xml.link(stop_url(stop))      
          xml.guid(stop_url(stop))      
          xml.author(stop.trip.user.email + "(" + stop.trip.user.login + ")" )
          xml.pubDate(stop.updated_at.to_s(:rfc822))
          description = '<p>' + stop.description.to_s + '</p>'
          for @photo in stop.photos
             description += '<br/><img src="'+root_url+url_for_file_column('photo', 'file')+'" />'
             description += '<p>' + @photo.caption.to_s + '</p>'
          end
          xml.description( description )
        end
      end
  }
}
