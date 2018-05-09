import MainView from '../main';

module.exports = class View extends MainView {
  startSubscribing() {
    const session = OT.initSession(apiKey, sessionId)

    session.on("streamCreated", function(event) {
      console.log(event, "event");
      bar = session.subscribe(event.stream, 'subscriber', {
        insertMode: 'append',
        width: '100%',
        height: '100%'
      }, handleError);
    })

    session.connect(token, handleError)
    session.subscribe
  }

  mount() {
    console.log('LiveStream Show mounted');
    console.log("subscribing");
    startSubscribing();
  }

  unmount() {
    console.log('LiveStream Show unmounted');
  }
};
