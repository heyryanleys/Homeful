var map;
var geocoder;
var markers = [];
var clicked_id;

var green_icon = 'https://maps.google.com/mapfiles/ms/icons/green-dot.png';
var yellow_icon = 'https://maps.google.com/mapfiles/ms/icons/yellow-dot.png';
var red_icon = 'https://maps.google.com/mapfiles/ms/icons/red-dot.png';

function initMap() {
  city = {
    lat: 42.3601,
    lng: -71.0589
  }
  map = new google.maps.Map(document.getElementById('map'), {
    center: city,
    zoom: 10

  });
  cdata = JSON.parse(document.getElementById('data').innerHTML);
  geocoder = new google.maps.Geocoder();
  codeAddress(cdata)
}

var previewWindow = false;

function codeAddress(cdata) {
  Array.prototype.forEach.call(cdata, function(data) {

    var contentString = '<div id="content" style="height:100%">'+
          '<div id="bodyContent">'+
          '<p><b>'+data.shelter_name+'</b></p>'+
          '<p><b>'+ data.available_rooms + ' available space(s)</b></p>'+
          '<p><a href="https://www.google.com/maps/search/?api=1&query='+ data.address + '+' + data.city + '+' + data.state + '" target="_blank">Directions</a></p>'+
          '<p><button id="shelter_name='+ data.shelter_name + '&shelter_address=' + data.address +'" class="book_a_room" onClick="reply_click(this.id)">Book a stay</button></p>'+
          '</div>'+
          '</div>';

    var infowindow = new google.maps.InfoWindow({
            content: contentString
          });

    var address = data.address + ' ' + data.city + ' ' + data.state + ' ' + data.latitude;

    if (data.latitude == null || data.longitude == null) {
      geocoder.geocode({
        'address': address

      }, function(results, status) {
        if (status == 'OK') {
          map.setCenter(results[0].geometry.location);
          if (parseInt(data.available_rooms) >= 10){
            var marker = new google.maps.Marker({
              map: map,
              position: {
                lat: parseFloat(data.latitude),
                lng: parseFloat(data.longitude)
              },
              icon: green_icon
            });
          }
          else if (parseInt(data.available_rooms) >= 1) {
            var marker = new google.maps.Marker({
              map: map,
              position: {
                lat: parseFloat(data.latitude),
                lng: parseFloat(data.longitude)
              },
              icon: yellow_icon
            });
          } else {
            if(parseInt(data.available_rooms) > 0){
              console.log('ya');
            };
            var marker = new google.maps.Marker({
              map: map,
              position: {
                lat: parseFloat(data.latitude),
                lng: parseFloat(data.longitude)
              },
              icon: red_icon
            });
          }

          markers.push(marker);
          marker.addListener('click', function() {
            if(previewWindow){
              previewWindow.close();
            }
            previewWindow = infowindow;
            infowindow.open(map, marker);
          });

          var loccy = results[0].geometry.location.toString().replace('(', '');
          loccy = loccy.replace(')', '');
          loccy = loccy.replace(' ', '');
          loccy = loccy.split(',');
          var latitude = parseFloat(loccy[0]);
          var longitude = parseFloat(loccy[1]);
          $.ajax({
            type: 'POST',
            url: '/updatelocation.php',
            data: {
              row: data.address,
              lat: latitude,
              lng: longitude
            },
            success: function(data) {
              console.log(data);
            }
          });
        } else {
          console.log('Geocode was not successful for the following reason: ' + status);
        }
      });
    } else {
      if (parseInt(data.available_rooms) >= 10){
        var marker = new google.maps.Marker({
          map: map,
          position: {
            lat: parseFloat(data.latitude),
            lng: parseFloat(data.longitude)
          },
          icon: green_icon
        });
      }
      else if (parseInt(data.available_rooms) >= 1) {
        var marker = new google.maps.Marker({
          map: map,
          position: {
            lat: parseFloat(data.latitude),
            lng: parseFloat(data.longitude)
          },
          icon: yellow_icon
        });
      } else {
        if(parseInt(data.available_rooms) > 0){
          console.log('ya');
        };
        var marker = new google.maps.Marker({
          map: map,
          position: {
            lat: parseFloat(data.latitude),
            lng: parseFloat(data.longitude)
          },
          icon: red_icon
        });
      }
      markers.push(marker);
      marker.addListener('click', function() {
        if(previewWindow){
          previewWindow.close();
        }
        previewWindow = infowindow;
        infowindow.open(map, marker);
      });
    }

  });
}

function updateTable(tableId, jsonData) {
  var tableHTML = "";
  var colnum = 1;
  for (var eachItem in jsonData) {
    tableHTML += "<tr>";
    var dataObj = jsonData[eachItem];
    for (var eachValue in dataObj) {
      if (eachValue == 'latitude' || eachValue == 'longitude') {
        continue;
      }
      if (eachValue == 'shelter_name'){
        var currShel = dataObj[eachValue];
      }
      if (eachValue == 'address'){
        var currAdd = dataObj[eachValue];
      }
      if (eachValue == 'available_rooms'){
        var able = 'enabled'
        if (dataObj[eachValue] >= 10){
          var spaceColor = 'green_space'
        } else if (dataObj[eachValue] > 0){
          var spaceColor = 'yellow_space'
        } else {
          var spaceColor = 'red_space'
          able = 'disabled'
        }
      }
      if (eachValue == 'available_rooms'){
        tableHTML += "<td class='col" + colnum + "'>" + dataObj[eachValue] + "</td>";
        if (colnum == 7){
          colnum = 1;
        } else {
        colnum += 1;
        }
        tableHTML += '<td class="col' + colnum + '"><button id="shelter_name=' + currShel + '&shelter_address=' + currAdd + ' " class="book_a_room ' + spaceColor + '" onClick="reply_click(this.id)" '+ able + '>Book a stay</button></td>';
        if (colnum == 7){
          colnum = 1;
        } else {
        colnum += 1;
      }
      }
      else if (dataObj[eachValue] == null) {
        tableHTML += "<td class='col" + colnum + "'></td>";
        if (colnum == 7){
          colnum = 1;
        } else {
        colnum += 1;
      }
      } else {
        tableHTML += "<td class='col" + colnum + "'>" + dataObj[eachValue] + "</td>";
        if (colnum == 7){
          colnum = 1;
        } else {
        colnum += 1;
      }
      }
    }
    tableHTML += "</tr>";

  }
  document.getElementById(tableId).innerHTML = tableHTML;
}

function openSpot(headerId, jsonData) {
  var headerHTML = "Browse ";
  var sumOfSpaces = 0;
  for (var eachItem in jsonData) {
    var dataObj = jsonData[eachItem];
    for (var eachValue in dataObj) {
      if (eachValue == 'available_rooms') {
        sumOfSpaces += parseInt(dataObj[eachValue]);
      }
    }

  }
  headerHTML += sumOfSpaces + " open spots in Boston shelters";
  document.getElementById(headerId).innerHTML = headerHTML;
}

function clearMarkers() {
  for (i = 0; i < markers.length; i++) {
    markers[i].setMap(null);
  }
}

function reply_click(clicked)
{
  clicked_id = clicked;
  document.getElementById('book_room').style.display = "block";
  text = clicked.split('&');
  document.getElementById('book_text').innerHTML = '<strong>' + text[0].substring(13) + '<strong>';
}

function xout(){
  document.getElementById('book_room').style.display = "none";
}

$(function() {
  $('#filter').on('submit', function(e) {
    console.log('hey');
    let default_city = 'FALSE';
    let default_demo = 'FALSE';
    let boston = default_city;
    var quincy = default_city;
    var cambridge = default_city;
    var mattapan = default_city;
    var roxbury = default_city;
    var somerville = default_city;
    var jamaica_plain = default_city;
    var brighton = default_city;
    var east_boston = default_city;
    var dorchester = default_city;
    var adult = default_demo;
    var family = default_demo;
    var women = default_demo;
    var asian = default_demo;
    var lgbtq = default_demo;
    var men = default_demo;
    var day = default_demo;
    var children = default_demo;
    var open = 'FALSE';

    input = $('#filter').serialize();

    var splitup = input.split('&');
    for (var item in splitup) {
      smaller_item = splitup[item].split('=');
      if (smaller_item[0] == 'boston') {
        boston = 'TRUE'
      };
      if (smaller_item[0] == 'quincy') {
        quincy = 'TRUE'
      };
      if (smaller_item[0] == 'cambridge') {
        cambridge = 'TRUE'
      };
      if (smaller_item[0] == 'mattapan') {
        mattapan = 'TRUE'
      };
      if (smaller_item[0] == 'roxbury') {
        roxbury = 'TRUE'
      };
      if (smaller_item[0] == 'somerville') {
        somerville = 'TRUE'
      };
      if (smaller_item[0] == 'jamaica_plain') {
        jamaica_plain = 'TRUE'
      };
      if (smaller_item[0] == 'brighton') {
        brighton = 'TRUE'
      };
      if (smaller_item[0] == 'east_boston') {
        east_boston = 'TRUE'
      };
      if (smaller_item[0] == 'dorchester') {
        dorchester = 'TRUE'
      };
      if (smaller_item[0] == 'adult') {
        adult = 'TRUE'
      };
      if (smaller_item[0] == 'family') {
        family = 'TRUE'
      };
      if (smaller_item[0] == 'women') {
        women = 'TRUE'
      };
      if (smaller_item[0] == 'asian') {
        asian = 'TRUE'
      };
      if (smaller_item[0] == 'lgbtq') {
        lgbtq = 'TRUE'
      };
      if (smaller_item[0] == 'men') {
        men = 'TRUE'
      };
      if (smaller_item[0] == 'day') {
        day = 'TRUE'
      };
      if (smaller_item[0] == 'children') {
        children = 'TRUE'
      };
      if (smaller_item[0] == 'open') {
        open = 'TRUE'
      };
    };

    var cities = [boston, quincy, cambridge, mattapan, roxbury, somerville, jamaica_plain, brighton, east_boston, dorchester];
    var demographics = [adult, family, women, asian, lgbtq, men, day, children];
    var opens = [open];

    var allCitiesFalse = 0;
    for (var item in cities) {
      if (cities[item] == 'TRUE') {
        allCitiesFalse = 1;
      }
    };

    var allDemosFalse = 0;
    for (var item in demographics){
      if(demographics[item] == 'TRUE'){
        allDemosFalse = 1;
      }
    }

    var allOpensFalse = 0
    for (var item in opens){
      if(demographics[item] == 'TRUE'){
        allOpensFalse = 1;
      }
    }

    if (allCitiesFalse < 1){
      boston = 'TRUE';
      quincy = 'TRUE';
      cambridge = 'TRUE';
      mattapan = 'TRUE';
      roxbury = 'TRUE';
      somerville = 'TRUE';
      jamaica_plain = 'TRUE';
      brighton = 'TRUE';
      east_boston = 'TRUE';
      dorchester = 'TRUE';
    }

    if (allDemosFalse < 1){
      adult = 'TRUE';
      family = 'TRUE';
      women = 'TRUE';
      asian = 'TRUE';
      lgbtq = 'TRUE';
      men = 'TRUE';
      day = 'TRUE';
      children = 'TRUE';
    }

    e.preventDefault();
      $.ajax({
        type: 'POST',
        url: 'filtertable.php',
        data: {
          boston: boston,
          quincy: quincy,
          cambridge: cambridge,
          mattapan: mattapan,
          roxbury: roxbury,
          somerville: somerville,
          jamaica_plain: jamaica_plain,
          brighton: brighton,
          east_boston: east_boston,
          dorchester: dorchester,
          adult: adult,
          family: family,
          women: women,
          asian: asian,
          lgbtq: lgbtq,
          men: men,
          day: day,
          children: children,
          open: open
        },
        success: function(data) {
          var parsed = JSON.parse(data);
          console.log(parsed);
          updateTable('main_table', parsed);
          clearMarkers();
          codeAddress(parsed);
        }
      });
  });
});



$(function() {
   var fname;
   var lname;
   var capacity;
   var shelter_name;
   var shelter_address;

  $('#stay').on('submit', function(e) {
    e.preventDefault();
    input = $('#stay').serialize();
    input = input+'&'+clicked_id;

    var splitup = input.split('&');
    for (var item  in splitup){
      smaller_item = splitup[item].split('=');
      if (smaller_item[0] == 'fname') {
          fname = smaller_item[1];
        };
      if (smaller_item[0] == 'lname') {
          lname = smaller_item[1];
        };
      if (smaller_item[0] == 'capacity') {
          capacity = parseInt(smaller_item[1]);
        };
      if (smaller_item[0] == 'shelter_name') {
          shelter_name = smaller_item[1];
        };
      if (smaller_item[0] == 'shelter_address') {
          shelter_address = smaller_item[1];
        };
    }

    // e.preventDefault();
      $.ajax({
        type: 'POST',
        url: 'bookstay.php',
        data: {
          fname: fname,
          lname: lname,
          capacity: capacity,
          shelter_name: shelter_name,
          shelter_address: shelter_address
        },
        success: function(data) {
          console.log('booked: ', data);
        }
      });
      window.location.reload()
  });


});
