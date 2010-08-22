parse_and_plot = function() {
	data = [];
	options = {
		selection: { mode: "xy" },
		points: { show: true },
		lines: { show: true },
		xaxis: { mode: '' },
		legend: { position: 'nw' }
	};

/* .text() only returns the text with all the html tags removed.  */
	jQuery.each(jQuery('#note_body').text().split('\n'), function(index, value) {
		d = value.split(/\s*#/);
		if( !d[0].blank() ){
			values = d[0].split(/\s*,\s*/);
			for( var i = 0; i <= ( values.length - 2 ) ; i++ ) {
				if( typeof(data[i]) == 'undefined' ){ data[i] = { label: 'Col'+(i+1), data:[] }; }
				d = values[0].to_date();
				if( i == 0 && d.valid() ){ options.xaxis = { mode: 'time' } }
				if( options.xaxis.mode == 'time' ){
					x = d.getTime();
				} else {
					x = values[0].to_f();
				}
				data[i].data.push([x,values[i+1].to_f()]);
			}
		}
	});

	jQuery("#flot_placeholder").show();
	jQuery.plot(jQuery("#flot_placeholder"), data, options );

	jQuery("#flot_placeholder").bind("plotselected", function (event, area) {
		jQuery.plot(jQuery("#flot_placeholder"), data,
			jQuery.extend(true, {}, options, {
				xaxis: { min: area.x1, max: area.x2 },
				yaxis: { min: area.y1, max: area.y2 }
		}));
	});

}
