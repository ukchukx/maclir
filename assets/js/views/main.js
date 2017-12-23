import SockerHandler from "../socket";
import MapHandler from "../map";

export default class MainView {
  mount() {
    this.userId = window.userUUID;

    this.showFlash();
    this.bootDropdown();
    
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

  bootDropdown() {
  	// The first click on a dropdown does nothing, so 
  	// let's get the first click out of the way
  	const el = document.querySelector('.navbar .nav-item.dropdown > a')
    if (el) el.click();
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
