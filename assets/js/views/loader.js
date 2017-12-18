import MainView from './main';
import PageHomeView from './page/home';
import SessionRegisterView from './session/register';

// Collection of specific view modules
const views = {
  PageHomeView,
  SessionRegisterView
};

export default function loadView(viewName) {
  return views[viewName] || MainView;
}
