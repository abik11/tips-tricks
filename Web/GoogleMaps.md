## Google Maps Api
If you want to learn and test the API you can add it to your HTML template like this:
```html
<div id="google-map"></div>
<script src="https://maps.googleapis.com/maps/api/js?callback=myMap"></script>
```
where **myMap** is the name of the function that will be responsible for the map configuration. The basic configuration of the map that will allow you display the map might look like here:
```javascript
function myMap(){
     var mapCanvas = document.getElementById("google-map");
     var mapOptions = {
          center: new google.maps.LatLng(51.508742, -0.120850),
          zoom: 5, 					// 0 - the lowest zoom
          mapTypeId: google.maps.MapTypeId.ROADMAP 	// ROADMAP, SATELLITE, HYBRID, TERRAIN
     }
     var map = new google.maps.Map(mapCanvas, mapOptions);
}
```

### Markers
Markers are easy way to mark some place on the map. They are built in the API and you can configure quite many properties.

##### Animated marker
```javascript
var marker = new google.maps.Marker({
    position: position,
    animation: google.maps.Animation.BOUNCE	// BOUNCE, DROP
});
marker.setMap(map);
```

##### Icon in place of marker
```javascript
var marker = new google.maps.Marker({
    position: position,
    icon: 'icon.png',
    draggable: true	// optional
});
marker.setMap(map);
```

##### Open information window on click
```javascript
var infowindow = 
      new google.maps.InfoWindow({
            content: 'Latitude: ' + location.lat() + '<br>Longitude: ' + location.lng()
      });

google.maps.event.addListener(marker, 'click', function() {
      infowindow.open(map, marker);
});
```

##### Remove events
```javascript
var listener = google.maps.event.addListener(marker, 'click', function() {});
google.maps.event.removeListener(listener);
```

##### Get current position of marker
```javascript
var pos = marker.getPosition();
```

##### Add marker on click
This is a nice example that will add a new marker on the map in the place where you will click and additionally it will open info window associated with the marker that will show the latitude and longitude. Moreover if you will click on the marker, it will be deleted.
```javascript
google.maps.event.addListener(map, 'click', function(event) {
     placeMarker(map, event.latLng);
});
	
function placeMarker(map, location) {
     var marker = new google.maps.Marker({
          position: location,
          map: map,
     });
		 
     var infowindow = new google.maps.InfoWindow({
          content: 'Latitude: ' + location.lat() + '<br>Longitude: ' + location.lng()
     });
     infowindow.open(map, marker);
		 
     google.maps.event.addListener(marker, 'click', function(event){
          marker.setMap(null);
     });
}
```
To delete a marker, the following line is used:
```javascript
marker.setMap(null);
```

### Drawing shapes
Sometimes markers are not enough to present some concepts on the map. But it is possible to draw any kind of shape.

##### Line
Line is the simplest shape you can draw.
```javascript
var flightPath = new google.maps.Polyline({
    path: [rome, amsterdam, london],
    strokeColor: "#0000FF",
    strokeOpacity: 0.8,
    strokeWeight: 2
});
flightPath.setMap(map);
```

##### Polygon
Polygon has the same properties as line with **fillColor** and **fillOpacity** additionaly.
```javascript
var flightPath = new google.maps.Polygon({
    path: [rome, amsterdam, london],
    strokeColor: "#0000FF",
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: "#0000FF",
    fillOpacity: 0.4
});
flightPath.setMap(map);
```

##### Circle
Circle has the same properties as Polygon but instead of defining the array of points (**path**), you define the center of the circle and radius in meters.
```javascript
var circle = new google.maps.Circle({
    center: new google.maps.LatLng(58.983991,5.734863),
    radius: 50000,
    strokeColor: "#0000FF",
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: "#0000FF",
    fillOpacity: 0.4,
    editable: true 		// optional
});
circle.setMap(map);
```

##### Rectangle
```javascript
var area = new google.maps.Rectangle({
    bounds: new google.maps.LatLngBounds(
        new google.maps.LatLng(17.342761, 78.552432),
        new google.maps.LatLng(16.396553, 80.727725)),
    strokeColor: "#0000FF",
    strokeOpacity: 0.8,
    strokeWeight: 2,
    fillColor: "#0000FF",
    fillOpacity: 0.4	
});
```

### Adjusting the map
There are many different things that can be adjusted on the map, from zoom and the center point up to colors and general styling.

##### Basic adjustments
* Zoom
```javascript
var zoom = map.getZoom();
map.setZoom(10);
```
* Center
```javascript
var center = map.getCenter();
map.setCenter(new google.maps.LatLng(51.508742, -0.120850));
```
* Tilt / angle<br />
You can set tilt only in **satelite** and **hybrid** mode and only with zoom higher than 18. Setting tilt to 0 will block the perspective:
```javascript
map.SetTilt(0);
```

##### Language
```html
<script src="https://maps.googleapis.com/maps/api/js?language=pl">
```

##### Changing map style
You can easily generate your own style [here](https://mapstyle.withgoogle.com/). Here you can see an example of how Google Maps style looks:
```javascript
var styles = [
    { "elementType": "geometry", 
      "stylers": [{ "color": "#242f3e" }]
    },
    { "elementType": "labels.text.fill", 
      "stylers": [{ "color": "#746855" }]
    },
    { "elementType": "labels.text.stroke", 
      "stylers": [{ "color": "#242f3e" }]
    },
    { "featureType": "administrative.locality"
      "elementType": "labels.text.fill", 
      "stylers": [{ "color": "#d59563" }]
    },
    { "featureType": "poi"
      "elementType": "labels.text.fill", 
      "stylers": [{ "color": "#d59563" }]
    },
    //...
];
```
There are many other objects that you can style, actually you can change everything. To add a style to the map you have to use **styles** property:
```javascript
var map = new google.maps.Map(mapCanvas, {
    center: { lat: 51.508742, lng: -0.120850 },
    zoom: 5,
    styles: styles
});
```

##### Adding style as a new map type
First create a map and specify another map type, for example *night*:
```javascript
var map = new google.maps.Map(mapCanvas, {
    center: { lat: 51.508742, lng: -0.120850 },
    zoom: 5,
    mapTypeControlOptions: {
        mapTypeIds: [ 'roadmap', 'satelite', 'hybrid', 'terrain', 'night' ]
    }
});
```
And than create a new map type:
```javascript
var nightMapType = new google.maps.StyledMapType(
    styles, 
    { name: "Night" }
);
```
and finally and the type to the map and set it:
```javascript
map.mapTypes.set('night', nightMapType);
map.setMapTypeId('night');
```

### Controls

##### Turn off useless controls
You can use the following properties in the map options:
```javascript
disableDefaultUI: true // turn off all controls

zoomControl: true,
scaleControl: true,                
streetViewControl: false,
mapTypeControl: false
```

##### Select map type control
```javascript
mapTypeControlOptions: { 
     style: google.maps.MapTypeControlStyle.DROPDOWN_MENU, 
     mapTypeIds: [ 
           google.maps.MapTypeId.ROADMAP,                                            
           google.maps.MapTypeId.TERRAIN 
     ] 
}
```
Button styles to choose are **DROPDOWN_MENU** and **HORIZONTAL_BAR**.

### Advanced
You can do much more with Google Maps, especially when it comes to showing the data on the map. Visualizing the information in the geographical context is a really nice use case for Google Maps and there are many different tools available.

##### Heatmap
To use heatmap functionality you have to use this URL: `https://maps.googleapis.com/maps/api/js?callback=myMap&libraries=visualization`. Then you have to prepare the data:
```javascript
var data = [new google.maps.LatLng(51.508742, -0.120850)]
var pointArray = new google.maps.MVCArray(data);
```
And apply the heatmap to the map with the data you have:
```javascript
heatmap = new google.maps.visualization.HeatmapLayer({ data: pointArray });
heatmap.setMap(map);
```
You can dynamically change heatmap configuration:
```javascript
var radius = heatmap.get('radius');
heatmap.set('radius', 20);

var opacity = heatmap.get('opacity');
heatmap.set('opacity', 0.2);

var gradient = heatmap.get('gradient');
heatmap.set('gradient', ['rgba(0,255,255,0)', 'rgba(0,255,255,1)', 'rgba(0,191,255,1)']);
```

##### Clustering markups
To allow markup clustering you have to include the following JS library: `https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/markerclusterer.js
`. Then you have to specify the array of markers that you want to cluster:
```javascript
var markerCluster = new MarkerClusterer
	(map, markers, { imagePath: 'https://developers.google.com/maps/documentation/javascript/examples/markerclusterer/m' });
```
