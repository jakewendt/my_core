require 'hpricot';
class Ripper
	attr_reader :url, :netflix_cookie, :titles
#	def initialize(netflix_cookie,pageNum=1)
#		@url = "http://www.netflix.com/MoviesYouveSeen?pageNum=#{pageNum}"
#		@pageNum = pageNum
	def initialize(netflix_cookie,url="http://www.netflix.com/MoviesYouveSeen" )
		@url = url
		@netflix_cookie = netflix_cookie
		@titles = []
	end

	def rip_all
#	this took a whole 555117 ms for me
#	need to find a more ajaxian way to do this 1 url at a time
#	perhaps add param to simply create the expected url format ...
#		http://www.netflix.com/MoviesYouveSeen?pageNum=2
#		while(@url) do
			rip
			rip if (@url)
#		end
	end

	def rip
		#	ruby probably has an internal equivalent of curl so check that out
puts "RIPPING '#{@url}'";
		page = `curl --get --cookie "#{@netflix_cookie}" '#{@url}'`;
	
		Hpricot.parse(page).search("table.listHeader>tr").each {|row| 
			title = row.search("td>div.list-title>a").first
			if( title )
				url = title.attributes['href'].sub(/\?trkid=\d+$/,'')
				rating = row.search("td>div.list-rating>div>span>span").first
				self.titles.push( 
					Ripper::Title.new(title.inner_text,url,rating.inner_text.sub(/You rated this movie: /,'') ) 
				);
			end
		}
		nextpage = Hpricot.parse(page).search("li.paginationLink-next>a").first
		nexturl = (!nextpage.nil?) ? nextpage.attributes['href'] : nil;
		@url = ( nexturl == @url ) ? nil : nexturl
	end

	class Title
		def initialize(title,url,rating)
			@title  = title
			@url    = url
			@rating = rating
		end
		attr_reader :title, :url, :rating
	end
end

