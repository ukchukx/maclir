import SockerHandler from "../socket";
import MapHandler from "../map";

export default class MainView {
  mount() {
    this.userId = window.userUUID;

    this.showFlash();
    
    this.socketHandler = new SockerHandler();
    this.mapHandler = new MapHandler(this.socketHandler);
    this.socketHandler.setMapHandler(this.mapHandler);

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
}
