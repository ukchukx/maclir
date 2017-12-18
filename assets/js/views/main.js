import styles from '../map_styles';

export default class MainView {
  mount() {
  	let mapComponent = new Vue({
      el: '#map',
      data() {
        return {
          zoom: 15,
          center: [9.1490051,7.3233646],
          markers: [
            { coords: [9.1490051,7.3233646], label: "~user1" },
            { coords: [9.1499061,7.3276318], label: "~user2"},
          ],
          mapOptions: { 
          	zoomControl: false,
          	attributionControl: false
          }
        }
      },
      beforeCreate() {
        navigator.geolocation.getCurrentPosition((position) => {
          console.log('position', position);
          this.center = [position.coords.latitude, position.coords.longitude];
          this.markers.push({ coords: [...this.center], label: "me" });
        }, (err) => console.log(err), { enableHighAccuracy: true });
      }
    });

    this.map = mapComponent.$refs.map.mapObject;
    this.roads = L.gridLayer.googleMutant({
      type: 'roadmap',
      styles: styles.mutedBlue
    }).addTo(this.map);

    L.control.zoom({
     	position:'bottomright'
		}).addTo(this.map);

    console.log('MainView mounted');
  }

  unmount() {
    console.log('MainView unmounted');
  }
}
