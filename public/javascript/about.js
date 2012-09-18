//$(document).ready(function(){
// });
//$.getJSON('http://www.google.com/latitude/apps/badge/api?user=7124255671275562153&type=json', function(data){
var map;
      function initialize() {
        var myOptions = {
          zoom: 16,
          center: new google.maps.LatLng(40.725324,-73.953931),
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

google.maps.event.addDomListener(window, 'load', initialize);

// $(document).ready(function(){
//   var   userid = '110334',
//         public_key = '507bc268681356f2',
//         end = new Date().getTime()
//         start = end - (14 * 24 * 60 * 60);
//         url = 'http://wbsapi.withings.net/measure?action=getmeas&userid=' + userid + '&publickey=' + public_key +'&startdate=' + start + '&enddate=' + end + '&limit=1&callback=?';

//         $.getJSON(url, function(data){
//           console.log(data)
//         })

// })

// console.log(data)
// })