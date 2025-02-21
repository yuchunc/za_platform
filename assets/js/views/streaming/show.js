import {Presence} from 'phoenix';
import socket from '../../socket';
import main from '../main';
import commentAction from '../util/comment';

const stream_id = window.streamConfig.stream_id;

let viewerCountElem = document.getElementById('viewer-count');

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
      let channel = socket.channel("stream:" + stream_id);
      let presence = new Presence(channel);
      let publisher;

      channel = socket.channel("stream:" + stream_id);
      channel.join();

      channel
        .push("streamer:show_start", {message: ""})
        .receive("ok", (resp) => {
          publisher = startStreaming(resp)

          // Takes snapshot when receive message
          channel.on("streamer:take_snapshot", (resp) => {
              uploadSnapshot(publisher, channel, resp.upload_key);
            })
        });

      commentAction(channel);
      console.log("pres", presence);

      presence.onSync(() => {
        let count = Object.keys(presence.list()).length
        viewerCountElem.innerHTML = count;
      });

      console.log('Streaming Show mounted');
    },

    unmount: () => {
      console.log('Streaming Show unmounted');
    }
  });
};
