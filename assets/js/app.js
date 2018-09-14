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

document.addEventListener('DOMContentLoaded', function () {

  // Controls the modal
  // document.querySelector('button#fb-login-button').addEventListener('click', function(event) {
  //   event.preventDefault();
  //   let modal = document.querySelector('#fb-login');  // assuming you have only 1
  //   let html = document.querySelector('html');
  //   modal.classList.add('is-active');
  //   html.classList.add('is-clipped');

  //   modal.querySelector('.modal-background').addEventListener('click', function(e) {
  //     e.preventDefault();
  //     modal.classList.remove('is-active');
  //     html.classList.remove('is-clipped');
  //   });
  // });

  // Get all "navbar-burger" elements
  let $navbarBurgers = Array.prototype.slice.call(document.querySelectorAll('.navbar-burger'), 0);

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {

    // Add a click event on each of them
    $navbarBurgers.forEach(function ($el) {
      $el.addEventListener('click', function () {

        // Get the target from the "data-target" attribute
        let target = $el.dataset.target;
        let $target = document.getElementById(target);

        // Toggle the class on both the "navbar-burger" and the "navbar-menu"
        $el.classList.toggle('is-active');
        $target.classList.toggle('is-active');

      });
    });
  }

});
