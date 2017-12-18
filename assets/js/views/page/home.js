import MainView from '../main';
import styles from '../../map_styles';


export default class View extends MainView {
  mount() {
    super.mount();
    let mapComponent = new Vue({
      el: '#map',
      data() {
        return {
          zoom: 15,
          center: [9.1490051,7.3233646],
          markers: [
            { coords: [9.1490051,7.3233646], label: "~user1" },
            { coords: [9.1499061,7.3276318], label: "~user2"},
          ]
        }
      },
      beforeCreate() {
        navigator.geolocation.getCurrentPosition((position) => {
          console.log('position', position);
          // this.center = [position.coords.latitude, position.coords.longitude];
        }, (err) => console.log(err), { enableHighAccuracy: true });
      }
    });

    this.map = mapComponent.$refs.map.mapObject;
    this.roads = L.gridLayer.googleMutant({
      type: 'roadmap',
      styles: styles.mutedBlue
    }).addTo(this.map);

    console.log('HomeView mounted');
  }

  unmount() {
    super.unmount();
    console.log('HomeView unmounted');
  }

  closest(el, selector, stopSelector) {
    let retval = null;
    while (el) {
      if (el.matches(selector)) {
        retval = el;
        break;
      } else if (stopSelector && el.matches(stopSelector)) {
        break;
      }
      el = el.parentElement;
    }
    return retval;
  }
}
