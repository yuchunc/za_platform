import {createChannel, joinChannel} from '../channel';
import main from '../main';

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


export default () => {
  return Object.assign(main(), {
    mount: () => {
      console.log('Streaming Show mounted');

      let channel = createChannel();
      joinChannel(channel);

      channel
        .push("streamer:show_start", {message: ""})
        .receive("ok", (resp) => {
          startStreaming(resp)
        });
    },

    unmount: () => {
      console.log('Streaming Show unmounted');
    }
  });
};
