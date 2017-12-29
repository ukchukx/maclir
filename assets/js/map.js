import SockerHandler from "./socket";
import styles from './map_styles';

class MapHandler {
  constructor(socketHandler) {
    this.socketHandler = socketHandler;
    this.userId = window.userUUID;
    this.userName = window.userName;
  	this.setupMap();
  }

  fetchLocation() {
    return new Promise((resolve, reject) => {
      navigator.geolocation.getCurrentPosition(
        position => resolve(position), 
        err => reject(err), 
        { enableHighAccuracy: true }
      );      
    })
  }

  setupMap() {
  	if (!document.querySelector('#map')) return;
    this.fetchLocation()
    .then((pos) => {
      console.log('position', pos);
      this.coords = [pos.coords.latitude, pos.coords.longitude];
      return true;
    },(err) => {
      console.error('position', err);
      toastr.error('Unable to get location. App will not function properly');
      this.watchLocation();
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
        this.markers = { [this.userId]: { marker, label: this.userName } };
        if (window.debug) console.log('setup marker', this.markers);
        this.socketHandler.pushLocationChange(this.userId, mapCenter);
        this.watchLocation();
      }
    });


  }

  watchLocation() {
    setTimeout(() => {
      this.fetchLocation()
      .then((pos) => {
        console.log('position update', pos);
        this.updateUserLocation(pos);
        this.watchLocation();
      })
    }, 30000);
  }

  addMarker({ coords, label }) {
    return L.marker(coords, { title: label })
      .bindPopup(label)
      .addTo(this.map);
  }

  setLocationFor({ id, latitude, longitude, username }) {
    if (!latitude || !longitude) return;

    if (!this.markers[id]) {
      this.markers[id] = { marker: this.addMarker({ label: username, coords: [latitude, longitude] }), label: username };
      if (window.debug) console.log('setLocationFor', this.markers);
      return;
    }

    this.markers[id].marker = this.markers[id].marker
      .setLatLng([latitude, longitude])
      .setPopupContent(username);
    this.markers[id].label = username;
    
    if (id === this.userId) this.map.flyTo([latitude, longitude]);
    if (window.debug) console.log('setLocationFor', this.markers);
  }

  updateUserLocation({ coords }) {
    const {latitude, longitude} = coords;
    if (latitude && longitude) {
      this.coords = [latitude, longitude];
      const payload = { id: this.userId, latitude, longitude, username: this.userName };
      this.setLocationFor(payload);
      this.socketHandler.pushLocationChange(payload);
    }
  }
}

export default MapHandler;
