import styles from '../map_styles';

export default class MainView {
  mount() {
  	this.showFlash();
  	this.setupMap();
  	this.bootDropdown();

    this.deleteForms =  [...document.querySelectorAll('form[data-confirm]')];

    this.deleteForms
      .map(form => form.addEventListener('submit', this.handleSubmit.bind(this), false));

    console.log('MainView mounted');
  }

  unmount() {
    navigator.geolocation.clearWatch(this.watchID);
    this.deleteForms
      .map(form => this.removeEventListener('submit', this.handleSubmit.bind(this), false));
    console.log('MainView unmounted');
  }

  bootDropdown() {
  	// The first click on a dropdown does nothing, so 
  	// let's get the first click out of the way
  	document.querySelector('.navbar .nav-item.dropdown > a').click();
  }

  handleSubmit(e) {
    e.preventDefault();
    e.stopPropagation();

    const confirmed = confirm(e.target.dataset.confirm);
    e.returnValue = confirmed;
    return confirmed;
  }

  showFlash() {
  	const 
  		error = document.querySelector('#error-flash'),
  		info = document.querySelector('#info-flash');

  	if (error && error.innerHTML) {
  		toastr.error(error.innerHTML);
  	}

  	if (info && info.innerHTML) {
  		toastr.info(info.innerHTML);
  	}
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
      console.err('position', err);
      toastr.error('Grant location access for this app to work');
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

        const markers = [
                { coords: [9.1490051,7.3233646], label: "~user1" },
                { coords: [9.1499061,7.3276318], label: "~user2"},
                { coords: mapCenter, label: "~me"},
              ];
        markers.map(mark => this.addMarker(mark)); 
        // Register a watcher for user location changes
        this.watchID = navigator.geolocation.watchPosition(this.updateUserLocation.bind(this));
      }
    });


  }

  addMarker({ coords, label }) {
    const marker = L.marker(coords, { title: label }).addTo(this.map);
    marker.bindPopup(label);
    return marker;
  }

  updateUserLocation(position) {
    const {latitude, longitude} = position.coords;
    this.map.panTo([latitude, longitude]);
  }
}
