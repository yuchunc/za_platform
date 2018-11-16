let renderViewersCount(presence, element) {
  element.innerHTML = Object.keys(presence.list()).length;
};

export default (presence, element) => {
  // onJoin
  // onLeave
  presence.onSync(() => renderViewersCount(presence));
};
