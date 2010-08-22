//alert(window.location.host);
//alert( $('table.listHeader tr td div.list-title a').eq(0).html() )
//$(function(){ alert('loaded'); });
//var out = window.open('');
//alert(document.cookie)
//alert(location.hostname);	// host and hostname are the same here, but host can include the port
/*
var s=document.createElement('script');
s.type='text/javascript';
s.src=file;
document.getElementsByTagName('head')[0].appendChild(s);
$('body').append(
	"<form id='initiate_ratings_rip' action='http://localhost:3000/notes' method='post'>"+
	"<textarea name='note[body]'>"+document.cookie+"</textarea>"+
	"<input type='submit'/>" +
	"</form>"
);
*/

var f = document.createElement('form');
f.style.display = 'none';
document.body.appendChild(f);
f.method = 'POST';
f.action = 'http://localhost:3000/notes';

var t = document.createElement('input');
t.setAttribute('type', 'hidden');
t.setAttribute('name', 'authenticity_token');
t.setAttribute('value', "qRY9zyInbPln9g7VmeHTEcN9UgsXtSl5BEhtCntwzLA=");
f.appendChild(t); 


var t = document.createElement('textarea');
t.setAttribute('name', 'note[body]');
//t.setAttribute('value', document.cookie);
t.value = document.cookie;
f.appendChild(t); 
f.submit();


//if( true ) {
	//	alert('ripping')

//	window.onload = function(){alert('loaded')};
//	window.onload(function(){alert('loaded')});
//	window.onload = "alert('loaded');"
//	window.location = $('li.paginationLink-next > a')[0].href;
//	window.location.href = $('li.paginationLink-next > a')[0].href;


/*
		really need to wrap this in a while loop or something
		also need to determine when the next page has finished loading

		OR find a way to take the cookies from the browser and use them in 
			a shell script calling curl as ...

curl --cookie "custTrans=G-5501975a-260b-4f87-b7f1-487501d09c73-1; country=1; NetflixShopperId=G-5501975a-260b-4f87-b7f1-487501d09c73-1; vstCnt=-6~-6~1259973833385; __qca=485595a0-8fb9d-05dcb-64447; VisitorId=88469479-0d9a-4329-92b5-8a9235adb127; s_sq=%5B%5BB%5D%5D; s_cc=true; nflxsid=112.1260002633384; lastHitTime=1260002633384; NetflixSession=112.d5dff6ce-d868-437d-9780-31e46e970049; NSC_xxx.ofugmjy.dpn=ffffffff09c83e6145525d5f4f58455e445a4a422d69" http://www.netflix.com/MoviesYouveSeen

			... does indeed work

$('table.listHeader tr').each(function(){
	$(this).find('td > div.list-title > a').each(function(){
		out.document.write( "<a href='"+this.href+"'>"+$(this).html()+"</a>" );
		out.document.write( "<br/>" );
	});
});


	window.location.replace( $('li.paginationLink-next > a')[0].href );
*/
/*
} else {
	alert('Need to open a window to write ratings.  Unblock pop-ups, please.');
}
*/
