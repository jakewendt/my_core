xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0", "xmlns:atom" =>"http://www.w3.org/2005/Atom" ){
  xml.channel{
    xml.title("#{@user.login}: Photos")
    xml.description("#{@user.login}: Photos on http://my.jakewendt.com")
#    xml.link(formatted_user_photos_url(@user,:rss))
    xml.link(user_photos_url(@user,:format => :rss))
    xml.language('en-us')
# feedvalidator.org
# recommended to add something like ...
# <atom:link href="http://dallas.example.com/rss.xml" rel="self" type="application/rss+xml" />
# but I don't know exactly how to do that
      for @photo in @photos
        xml.item do
          xml.title(@photo.file_before_type_cast)
          xml.link(photo_url(@photo))
          xml.guid(photo_url(@photo))
          xml.author(@photo.user.login)
          xml.pubDate(@photo.updated_at.to_s(:rfc822))
          description  = ( @photo.file.blank? ) ? 'No file' : '<img src="'+root_url+url_for_file_column('photo', 'file')+'" />'
          description += '<p>' + @photo.caption.to_s + '</p>'
          xml.description( description )
        end
      end
  }
}
