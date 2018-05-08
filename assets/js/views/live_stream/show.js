import MainView from '../main';

module.exports = class View extends MainView {
  mount() {
    console.log('LiveStream Show mounted');
  }

  unmount() {
    console.log('LiveStream Show unmounted');
  }
};
