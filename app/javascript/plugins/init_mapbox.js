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
    const poster = JSON.parse(mapElement.dataset.poster);
    const map = new mapboxgl.Map({
      container: 'map',
      style: poster.theme,// || 'mapbox://styles/mapbox/streets-v11',
      preserveDrawingBuffer: true,
    });

    const markersSet = JSON.parse(mapElement.dataset.markers);
    const lines = [];
    const colorsSet = JSON.parse(mapElement.dataset.routeColors);
    markersSet.forEach((markers, index) => {
      lines.push([])
      const lineGradient = [
        'interpolate',
        ['linear'],
        ['line-progress']
      ].concat(colorsSet[index])
      markers.forEach((marker) => {
        lines[index].push([marker.lng, marker.lat])
        // const mk = document.createElement('div');
        // mk.className = 'marker';
        // mk.style.backgroundColor = 'red';
        // mk.style.borderRadius = '50%';
        // mk.style.width = '5px';
        // mk.style.height = '5px';
        // mk.style.display = 'none';
  
        // new mapboxgl.Marker(mk)
        //   .setLngLat([ marker.lng, marker.lat ])
        //   .addTo(map);
      });
      map.on('load', () => {
        map.addSource(`route${index}`, {
          'type': 'geojson',
          'lineMetrics': true,
          'data': {
            'type': 'Feature',
            'properties': {},
            'geometry': {
            'type': 'LineString',
            'coordinates': lines[index]
            }
          }
        });
        map.addLayer({
          'id': `route${index}`,
          'type': 'line',
          'source': `route${index}`,
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
    })
    fitMapToMarkers(map, markersSet.flat());
    document.querySelector("#map-container").style.transform = "scale(0.2)"
  }
};

export { initMapbox };