//$(document).ready(function(){
// });
//$.getJSON('http://www.google.com/latitude/apps/badge/api?user=7124255671275562153&type=json', function(data){
  var map;

  function initialize(lat, lon) {
    var myOptions = {
      zoom: 16,
      center: new google.maps.LatLng(lat,lon),
      mapTypeId: google.maps.MapTypeId.ROADMAP,

    };
    map = new google.maps.Map(document.getElementById('map'), myOptions);
    testMarker(map) 
  }

  // Function for adding a marker to the page.
  function addMarker(location) {
      marker = new google.maps.Marker({
          position: location,
          map: map
      });
  }

  // Testing the addMarker function
  function testMarker() {
         myHouse = new google.maps.LatLng(40.725324,-73.953931);
         addMarker(myHouse);
  }

$( document ).ready(function(){
    var lat = $('#lat').html(),
        lon = $('#lon').html()

    initialize(lat, lon)

})
