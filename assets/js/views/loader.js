import MainView from './main';

export default (viewPath) => {
  let view;

  try {
    const viewFactory = require('./' + viewPath);
    console.log("ping", viewFactory.default());
    view = viewFactory.default();
  } catch(e) {
    view = Object.create(MainView());
  };

  return view;
}
