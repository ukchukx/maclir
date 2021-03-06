import MainView from '../main';


export default class View extends MainView {
  mount() {
    super.mount();
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
