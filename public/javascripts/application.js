jQuery(function(){

	jQuery('#encrypt').click(function(){
		Encrypt_ID('note_body');
		return false;
	});

	jQuery('#decrypt').click(function(){
		Decrypt_ID('note_body');
		return false;
	});

	jQuery('#parse_and_plot').click(function(){
		parse_and_plot();
		return false;
	});

	/* hide inline and show via javascript.  This way, if javascript is disabled,
		they won't be visible since they trigger sorting via javascript. */
	jQuery('div#sort_select_tags').show();

	jQuery('p.flash').click(function(){$(this).hide();});

	jQuery('div#sort_select_tags select.dir').change(function(){
		if( window.location.href.match(/(dir=)\w*/) ){
				window.location = window.location.href.replace(/(dir=)\w*/, '$1'+this.value)
		} else {
				if( window.location.href.match(/\?/) ){
						window.location = window.location.href.concat("&dir="+this.value)
				} else {
						window.location = window.location.href.concat("?dir="+this.value)
				}
		}
	});

	jQuery('div#sort_select_tags select.sort').change(function(){
		if( window.location.href.match(/(sort=)\w*/) ){
				window.location = window.location.href.replace(/(sort=)\w*/, '$1'+this.value)
		} else {
				if( window.location.href.match(/\?/) ){
						window.location = window.location.href.concat("&sort="+this.value)
				} else {
						window.location = window.location.href.concat("?sort="+this.value)
				}
		}
	});

	jQuery('div#new_filters').show();
	jQuery('div#new_filters select.filter').change(function(){
		if( !this.value.blank() ){
			new_url = window.location.href.concat(( /\?/.test(window.location.href) )?"&":"?")
			window.location = new_url.concat(this.name+"="+encodeURIComponent(this.value))
		}
	});

});


String.prototype.to_msec = function() {
	if(this.length == 8){
		d = Date.UTC(this.substr(0,4), this.substr(4,2).to_i()-1, this.substr(6,2));
		return d;
	}
	return parseFloat(this);
}

String.prototype.to_f = function() {
	return parseFloat(this);
}

String.prototype.to_i = function() {
	// MUST add the radix as parsing dates gives leading 0s with will cause it to be octal.
	return parseInt(this,10);
}

String.prototype.blank = function() {
	return /^\s*$/.test(this);
}

String.prototype.to_date = function(){
// don't quite understand it, but I need to convert this string to a string?
// otherwise it is invalid
	d = new Date(this.toString());
	if( !d.valid() ) {
		if(this.length == 8){
			d = new Date(this.substr(0,4), this.substr(4,2).to_i()-1, this.substr(6,2));
		}
	}
	return d;
}

String.prototype.decodeURI = function() {
	return decodeURI(this);
}

Date.prototype.valid = function(){
	return (this != "Invalid Date");
}

/* I just finished this and I can't remember why I even started!!!!! */
params = function(){
	search = window.location.search.replace(/^\?/,'').split('&');
	p = new Object();
	for(i=0;i<search.length;i++) {
		[key,value] = search[i].decodeURI().split('=');
		if( /\[\]$/.test(key) ) {
			key = key.replace(/\[\]$/,'');
			if( typeof(p[key]) == 'undefined' ){
				p[key] = new Array();
			}
			p[key].push(value);
		} else {
			p[key] = value;
		}
	}
	return p;
}
