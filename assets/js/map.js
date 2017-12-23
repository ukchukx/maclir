import SockerHandler from "./socket";
import styles from './map_styles';

class MapHandler {
  constructor(socketHandler) {
    this.socketHandler = socketHandler;
    this.userId = window.userUUID;
    this.userName = window.userName;
  	this.setupMap();
  }

  setupMap() {
  	if (!document.querySelector('#map')) return;
    new Promise((resolve, reject) => {
      navigator.geolocation.getCurrentPosition(
        position => resolve(position), 
        err => reject(err), 
        { enableHighAccuracy: true }
      );      
    })
    .then((pos) => {
      console.log('position', pos);
      this.coords = [pos.coords.latitude, pos.coords.longitude];
      return true;
    },(err) => {
      console.error('position', err);
      toastr.error('Unable to get location. App will not function properly');
      return false;
    })
    .then((hasCoords) => {
      if (hasCoords) {
        const mapCenter = [...this.coords];
        const zoomLevel = 15;

        this.map = L.map('map', {
          zoomControl: false,
          attributionControl: false
        })
        .setView(mapCenter, zoomLevel);

        this._roadMap = L.gridLayer.googleMutant({
          type: 'roadmap',
          styles: styles.mutedBlue
        }).addTo(this.map);

        L.control.zoom({
         	position:'bottomright'
    		}).addTo(this.map);

        const marker = this.addMarker({ coords: mapCenter, label: this.userName });
        this.markers = [{ [this.userId]: { marker, label: this.userName } }];
        this.socketHandler.pushLocationChange(this.userId, mapCenter);
        // Register a watcher for user location changes
        this.watchID = navigator.geolocation.watchPosition(this.updateUserLocation.bind(this));
      }
    });


  }

  addMarker({ coords, label }) {
    return L.marker(coords, { title: label })
      .addTo(this.map)
      .bindPopup(label);
  }

  setLocationFor({ id, latitude, longitude, username }) {
    if (!this.markers[id]) {
      this.markers[id] = this.addMarker({ label: username, coords: [latitude, longitude] });
      return;
    }

    this.markers[id].marker = this.markers[id].marker.setLatLng([latitude, longitude]);
    if (id === this.userId) this.map.flyTo([latitude, longitude]);
  }

  updateUserLocation({ coords }) {
    const {latitude, longitude} = coords;
    this.coords = [latitude, longitude];
    const payload = { id: this.userId, latitude, longitude, username: this.userName };
    this.setLocationFor(payload);
    this.socketHandler.pushLocationChange(payload);
  }
}

export default MapHandler;
