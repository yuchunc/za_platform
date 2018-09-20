import socket from '../../socket';
import main from '../main';
import commentAction from '../util/comment';

const streamer_id = window.streamConfig.streamer_id;

const startStreaming = (ot_config) => {
  const session = OT.initSession(ot_config.key, ot_config.session_id);

  // Create a publisher
  const publisher = OT.initPublisher('stream-view', {
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

  return publisher;
}

const uploadSnapshot = (publisher, channel, key) => {
  const imgData = publisher.getImgData();
  const payload = {upload_key: key, snapshot: imgData};

  channel.push("streamer:upload_snapshot", payload);
};

export default () => {
  return Object.assign(main(), {
    mount: () => {
      console.log('Streaming Show mounted');

      let channel = socket.channel("stream:" + streamer_id);
      let publisher;

      channel = socket.channel("stream:" + streamer_id);
      channel.join();

      channel
        .push("streamer:show_start", {message: ""})
        .receive("ok", (resp) => {
          publisher = startStreaming(resp)

          // Takes snapshot when receive message
          channel.on("streamer:take_snapshot", (resp) => {
              uploadSnapshot(publisher, channel, resp.upload_key);
            })
        })

      commentAction(channel);
    },

    unmount: () => {
      console.log('Streaming Show unmounted');
    }
  });
};
