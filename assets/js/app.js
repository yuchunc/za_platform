// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html";
import "popper.js";

import "@opentok/client";
//import "@fortawesome/fontawesome-free/js/all.js";
import "../fontawesome-pro-5.2.0-web/js/all.js";

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

import loadView from './views/loader';

function handleDOMContentLoaded() {
  const viewName = document.getElementsByTagName('body')[0].dataset.jsViewPath;
  const view = loadView(viewName);

  view.mount();

  window.currentView = view;
}

function handleDocumentUnload() {
  window.currentView.unmount();
}

window.addEventListener('DOMContentLoaded', handleDOMContentLoaded, false);
window.addEventListener('unload', handleDocumentUnload, false);

let sidebar = document.querySelector('.z-sidebar');
let sidebarToggle = document.querySelector('.sidebar-toggle');

sidebarToggle.addEventListener('click', () => {
  console.log("ping");
  sidebar.classList.toggle("is-collapsed");

  if(sidebar.classList.contains("is-collapsed")) {
    sidebarToggle.innerHTML = '<i class="fal fa-angle-double-left"></i>';
  } else {
    sidebarToggle.innerHTML = '<i class="fal fa-angle-double-right"></i>';
  };
});
