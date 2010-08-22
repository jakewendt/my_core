jQuery.noConflict();	// so doesn't muck up prototype
jQuery(function() {
	jQuery('input.default').each( function() {
		if ( !jQuery(this).attr('default') ) {
			jQuery(this).attr('default', this.id);
		}
		this.value = jQuery(this).attr('default');
		this.type = 'text';
	});
	jQuery('input.default').focus( function() {
		if ( this.value == jQuery(this).attr('default') ) {
			this.value = "";
		}
	});
	jQuery('input.default').blur( function() {
		if ( this.value == "" ) {
			this.value = jQuery(this).attr('default');
		} else if ( jQuery(this).hasClass('password') ) {
			this.type = 'password';
		}
	});
});
/*
jQuery.noConflict();	// so doesn't muck up prototype
$(function() {
	$('input.default').each( function() {
		if ( !$(this).attr('default') ) {
			$(this).attr('default', this.id);
		}
		this.value = $(this).attr('default');
		this.type = 'text';
	});
	$('input.default').focus( function() {
		if ( this.value == $(this).attr('default') ) {
			this.value = "";
		}
	});
	$('input.default').blur( function() {
		if ( this.value == "" ) {
			this.value = $(this).attr('default');
		} else if ( $(this).hasClass('password') ) {
			this.type = 'password';
		}
	});
});
*/
