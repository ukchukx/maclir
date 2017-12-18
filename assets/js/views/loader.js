import MainView from './main';
import PageHomeView from './page/home';

// Collection of specific view modules
const views = {
  PageHomeView,
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
