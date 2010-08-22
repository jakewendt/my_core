var map;
var markers = new Array;

function initialize(lat, lng, zoom) {
  if ( GBrowserIsCompatible() ) {
    map = new GMap2(jQuery('#tripmap')[0]);
    map.setCenter(new GLatLng(lat, lng), zoom);
    map.addControl(new GLargeMapControl());
    addMarkers();
  }
}

/*

  should add

  map.getCenter().x
  map.getCenter().y
  map.getZoom()

  to trip/edit

*/

function addMarkers() {
  // Create a base icon for all of our markers that specifies the
  // shadow, icon dimensions, etc.
  var baseIcon = new GIcon();
  baseIcon.shadow = "http://www.google.com/mapfiles/shadow50.png";
  baseIcon.iconSize = new GSize(20, 34);
  baseIcon.shadowSize = new GSize(37, 34);
  baseIcon.iconAnchor = new GPoint(9, 34);
  baseIcon.infoWindowAnchor = new GPoint(9, 2);
  baseIcon.infoShadowAnchor = new GPoint(18, 25);
  var letteredIcon = new GIcon(baseIcon);
  for (var i=0; i < markers.length; i++ ) {
    // Create a lettered icon for this point using our icon class
    // Need to deal with possibility of more than 26 markers so restart at A
    var l = i;
    while(l>25){ l -= 26 }
    var letter = String.fromCharCode("A".charCodeAt(0) + l);
    letteredIcon.image = "http://www.google.com/mapfiles/marker" + letter + ".png";
    markerOptions = { icon:letteredIcon };
    map.addOverlay( createMarker( i, markerOptions ) );
  }
}

function createMarker( index, options) {
  // The marker has to be created in a separate function
  // to preserve the markers index
  var latlng = new GLatLng(markers[index].lat, markers[index].lng);
  var marker = new GMarker(latlng, options);
  GEvent.addListener(marker,"click", function() {
    window.location = markers[index].link;
  });
  return marker;
}
