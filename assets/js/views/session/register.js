import MainView from '../main';

export default class View extends MainView {
  mount() {
    super.mount();

    this.form = document.getElementById('register-form');
    this.phoneInput = document.getElementById('phone');
    this.latInput = document.getElementById('lat-input');
    this.longInput = document.getElementById('long-input');

    this.form.addEventListener('submit', this.handleSubmit.bind(this), false); 
    this.setCoords();
    console.log('RegisterView mounted');
  }

  unmount() {
    super.unmount();
    this.form.removeEventListener('submit', this.handleSubmit.bind(this), false); 
    console.log('RegisterView unmounted');
  }

  handleSubmit(e) {
    e.preventDefault();
    e.stopPropagation();

    if (!!this.latInput.value && !!this.longInput.value && this.validatePhone()) { // TODO: Check if they are actually coordinates
      e.returnValue = true;
      return true;
    }

    if (!this.validatePhone()) toastr.error('Phone number not valid.');
    if (!this.latInput.value) toastr.error('App will not work without location');

    e.returnValue = false;
    return true;
  }

  validatePhone() {
    return /^\+?\d{1,15}$/g.test(this.phoneInput.value);
  }

  setCoords() {
    console.log('setting coords...');
    navigator.geolocation.getCurrentPosition(
      (position) => {
        this.latInput.value = position.coords.latitude;
        this.longInput.value = position.coords.longitude;
      }, 
      (err) => {
        toastr.error('This app cannot function without location access.');
        document.getElementById('register-button').disabled = true;
        setTimeout(this.setTimeout.bind(this), 5000);
      }, 
      { enableHighAccuracy: true }
    );
  }
}
