import mapboxgl from '!mapbox-gl';
import 'mapbox-gl/dist/mapbox-gl.css';

const initMapbox = () => {
  const mapElement = document.getElementById('map');

  const fitMapToMarkers = (map, markers) => {
    const bounds = new mapboxgl.LngLatBounds();
    markers.forEach(marker => bounds.extend([ marker.lng, marker.lat ]));
    map.fitBounds(bounds, { padding: 70, maxZoom: 15, duration: 0 });
  };

  if (mapElement) { // only build a map if there's a div#map to inject into
    mapboxgl.accessToken = mapElement.dataset.mapboxApiKey;
    const map = new mapboxgl.Map({
      container: 'map',
      style: 'mapbox://styles/mapbox/streets-v11',
    });

    const markers = JSON.parse(mapElement.dataset.markers);
    const lines = [];
    console.log(mapElement.dataset)
    const colors = JSON.parse(mapElement.dataset.routeColors);
    const lineGradient = [
      'interpolate',
      ['linear'],
      ['line-progress']
    ].concat(colors)
    console.log(lineGradient)
    markers.forEach((marker, index) => {
      lines.push([marker.lng, marker.lat])
      const mk = document.createElement('div');
      mk.className = 'marker';
      mk.style.backgroundColor = 'red';
      mk.style.borderRadius = '50%';
      mk.style.width = '5px';
      mk.style.height = '5px';

      new mapboxgl.Marker(mk)
        .setLngLat([ marker.lng, marker.lat ])
        .addTo(map);
    });
    console.log(colors)
    map.on('load', () => {
      map.addSource('route', {
        'type': 'geojson',
        'lineMetrics': true,
        'data': {
          'type': 'Feature',
          'properties': {},
          'geometry': {
          'type': 'LineString',
          'coordinates': lines
          }
        }
      });
      map.addLayer({
        'id': 'route',
        'type': 'line',
        'source': 'route',
        'layout': {
        'line-join': 'round',
        'line-cap': 'round'
        },
        'paint': {
        'line-color': '#000',
        'line-gradient': lineGradient,
        'line-width': 8
        }
        });
      });
    fitMapToMarkers(map, markers);
  }
};

export { initMapbox };