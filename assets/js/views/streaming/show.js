import main from '../main';

const startStreaming = () => {
  const config = window.streamConfig;
  const session = OT.initSession(config.key, config.sessionId);

  // Create a publisher
  const publisher = OT.initPublisher('publisher', {
    insertMode: 'append',
    width: '100%',
    height: '100%'
  }, main.handleError);

  // Connect to the session
  session.connect(config.token, (error) => {
    // If the connection is successful, publish to the session
    if (error) {
      main.handleError(error);
    } else {
      session.publish(publisher, main.handleError);
    }
  });
}


export default () => {
  return Object.assign(main(), {
    mount: () => {
      console.log('Streaming Show mounted');
      console.log("Start Streaming");
      startStreaming();
    },

    unmount: () => {
      console.log('Streaming Show unmounted');
    }
  });
};
