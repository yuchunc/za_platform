import socket from '../../socket';
import main from '../main';

const streamer_id = window.streamConfig.streamer_id;

const startStreaming = (ot_config) => {
  const session = OT.initSession(ot_config.key, ot_config.session_id);

  // Create a publisher
  const publisher = OT.initPublisher('publisher', {
    insertMode: 'append',
    width: '100%',
    height: '100%'
  }, main.handleError);

  // Connect to the session
  session.connect(ot_config.token, (error) => {
    // If the connection is successful, publish to the session
    if (error) {
      main.handleError(error);
    } else {
      session.publish(publisher, main.handleError);
    }
  });
}

const uploadSnapshot = (publisher) => {
  const imgData = publisher.getImgData();

  // sends imgData to server
};

export default () => {
  return Object.assign(main(), {
    mount: () => {
      console.log('Streaming Show mounted');

      let channel = socket.channel("stream:" + streamer_id);
      channel.join();

      channel
        .push("streamer:show_start", {message: ""})
        .receive("ok", (resp) => {
          startStreaming(resp)

          // setInterval(uploadSnapshot, 1000 * 60 * 20);
        });
    },

    unmount: () => {
      console.log('Streaming Show unmounted');
    }
  });
};
