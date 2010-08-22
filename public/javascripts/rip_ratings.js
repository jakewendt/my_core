// host and hostname are the same here, but host can include the port
if( /netflix/.test(location.hostname) ){

	var f = document.createElement('form');
	f.style.display = 'none';
	document.body.appendChild(f);
	f.method = 'POST';
	f.action = 'http://localhost:3000/rip_ratings';

	var t = document.createElement('textarea');
	t.setAttribute('name', 'netflix_cookie');
	t.value = document.cookie;
	f.appendChild(t); 
	f.submit();

} else {
	alert('This bookmarklet requires that you be at a netflix site.');
}
