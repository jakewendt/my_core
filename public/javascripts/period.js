/*
	Why the hell does adding some
	Array.prototype....
	cause plotting to fail in jquery.flot.js????
	Change jquery.flot.js line 180 from
		for( var i in res ) {
	to
		for(i=0;i<res.length;i++) {
	for/in includes user defined prototype properties
	which doesn't work
*/

Array.prototype.average = function() {
	sum = 0.0;
	for(i=0;i<this.length;i++)
		sum += this[i];
	return sum/this.length;
}

/* true_variance */
Array.prototype.variance = function() {
	sum = 0.0;
	ave = this.average()
	for(i=0;i<this.length;i++)
		sum += Math.pow(this[i]-ave,2);
	return sum / (this.length - 1);
}

Array.prototype.y = function() {
	y = new Array();
	for(i=0;i<this.length;i++) {
		if ( this[i] instanceof Array ) {
			y.push(this[i][1]);
		} else {
			y.push(this[i].y);
		}
	}
	return y;
}

Array.prototype.y_variance = function() {
	return this.y().variance();
}

Array.prototype.time_to_phase = function(period) {
	phase = new Array();
	for(i=0;i<this.length;i++)
		phase.push([ ( this[i].x % period ) / period, this[i].y ] );
//		phase.push([ this[i][0] % period, this[i][1] ] );
	return phase.sort( function(a,b){ return (a[0]<b[0])?-1:(a[0]>b[0])?1:0 } );
}

Array.prototype.double_phase = function() {
	l = this.length;
	for(i=0;i<l;i++)
//		this.push( [ 1 + this[i].x, this[i].y ] );
		this.push( [ 1 + this[i][0], this[i][1] ] );
}
Array.prototype.overall_variance = function(bins,covers) {
	// Requires SortXAscending and DoublePhase first to properly function
	true_count = this.length / 2;
	temp_sum = 0;
	for(cover=1;cover<=covers;cover++){
		BinStart = (cover - 1) / (bins * covers);
		element = 0;
		while ( ( element < this.length ) && ( this[element][0] < BinStart ) ) element++;	//	skip 
		for(bin=1;bin<=bins;bin++){
			BinEnd = ((bin * covers) + cover - 1) / (bins * covers);
			a = new Array();
			while ( ( element < this.length )
				&& ( this[element][0] >= BinStart )
				&& ( this[element][0] <  BinEnd ) ) {
				a.push(this[element]);
				element++;
			}
			if ( a.length > 1 ) {			
				BinVariance = a.y().variance();
				temp_sum += (BinVariance * (a.length-1));
			}
			BinStart = BinEnd;
		}	//	Bin
	}	//	Cover
	return (temp_sum / ((covers * true_count) - (covers * bins)));
}

Array.prototype.string_length = function() {
	var sl = 0;
	for ( i=0; i< this.length-1 ; i++ ) {
		sl += Math.abs( this[i+1][1] - this[i][1] );
	}
	sl += Math.abs( this[0][1] - this[this.length-1][1] );
	return sl;
}

/*
parse_and_plot();
p = data[0].data.time_to_phase(12.56); 
p.double_phase(); 
p.string_length();
*/

function sl_pdg(p_start,p_stop,p_delta) {
	pdgm = new Array();
	for( p=p_start;p<=p_stop;p+=p_delta ){
		phase = data[0].data.time_to_phase(p);
		sl = phase.string_length();
		pdgm.push([p,sl]);
	}
	if( jQuery('#pdg').length == 0 )
		jQuery('div.controlframe').after("<div id='pdg' class='flot'></div>");
	options = {
		points: { show: true }
	};
	jQuery("#pdg").show();
	jQuery.plot(jQuery("#pdg"), [pdgm], options );
}

function var_pdg(p_start,p_stop,p_delta) {
	pdgm = new Array();
	for( p=p_start;p<=p_stop;p+=p_delta ){
		phase = data[0].data.time_to_phase(p);
		phase.double_phase();
		v = phase.overall_variance(5,2);
		pdgm.push([p,v]);
	}
	if( jQuery('#pdg').length == 0 )
		jQuery('div.controlframe').after("<div id='pdg' class='flot'></div>");
	options = {
		points: { show: true }
	};
	jQuery("#pdg").show();
	jQuery.plot(jQuery("#pdg"), [pdgm], options );
}
