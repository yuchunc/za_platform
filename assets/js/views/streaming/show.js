import MainView from '../main';

module.exports = class View extends MainView {
  startStreaming() {
    const session = OT.initSession(key, session_id);

    // Create a publisher
    const publisher = OT.initPublisher('publisher', {
      insertMode: 'append',
      width: '100%',
      height: '100%'
    }, handleError);

    // Connect to the session
    ot_session = session.connect(token, (error) => {
      // If the connection is successful, publish to the session
      if (error) {
        handleError(error);
      } else {
        session.publish(publisher, handleError);
      }
    });
  }

  mount() {
    console.log('Streaming Show mounted');
    //console.log("Start Streaming");
    //startStreaming();
  }

  unmount() {
    console.log('Streaming Show unmounted');
  }
}
