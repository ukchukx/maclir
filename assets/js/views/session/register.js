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

    if (this.latInput.value && this.longInput.value && this.validatePhone()) { // TODO: Check if they are actually coordinates
      e.returnValue = true;
      return true;
    }

    e.returnValue = false;
    return true;
  }

  validatePhone() {
    const str = this.phoneInput.value.trim();
    return !!str.length && /^(\+?2340?|0)\d{10}$/g.test(str);
  }

  setCoords() {
    navigator.geolocation.getCurrentPosition(
      (position) => {
        this.latInput.value = position.coords.latitude;
        this.longInput.value = position.coords.longitude;
      }, 
      (err) => {
        toastr.error('This app cannot function without location access.');
        document.getElementById('register-button').disabled = true;
      }, 
      { enableHighAccuracy: true }
    );
  }
}
