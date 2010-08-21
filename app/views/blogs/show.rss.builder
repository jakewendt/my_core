xml.instruct! :xml, :version=>"1.0" 
xml.rss(:version=>"2.0", "xmlns:atom" =>"http://www.w3.org/2005/Atom" ){
  xml.channel{
    xml.title(@blog.title)
    xml.description(@blog.description)
    xml.link(blog_url(@blog, :format => :rss))
    xml.language('en-us')
# feedvalidator.org
# recommended to add something like ...
# <atom:link href="http://dallas.example.com/rss.xml" rel="self" type="application/rss+xml" />
# but I don't know exactly how to do that
      for entry in @blog.entries
        xml.item do
          xml.title(entry.title)
          xml.link(entry_url(entry))      
          xml.guid(entry_url(entry))      
          xml.author(entry.blog.user.email + "(" + entry.blog.user.login + ")" )
          xml.pubDate(entry.updated_at.to_s(:rfc822))
          description = '<p>' + entry.body.to_s + '</p>'
          for @photo in entry.photos
             description += '<br/><img src="'+root_url+url_for_file_column('photo', 'file')+'" />'
             description += '<p>' + @photo.caption.to_s + '</p>'
          end
          xml.description( description )
        end
      end
  }
}
