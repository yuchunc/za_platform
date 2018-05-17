import socket from '../../socket';
import main from '../main';

const streamer_id = window.streamConfig.streamer_id;

const startSubscribing = (ot_config) => {
  const session = OT.initSession(ot_config.key, ot_config.session_id)

  session.on("streamCreated", function(event) {
    console.log(event, "event");
    bar = session.subscribe(event.stream, 'subscriber', {
      insertMode: 'append',
      width: '100%',
      height: '100%'
    }, main.handleError);
  })

  session.connect(ot_config.token, main.handleError)
  session.subscribe
};

export default () => {
  return Object.assign(main(), {
    mount: () => {
      console.log('LiveStream Show mounted');

      let channel = socket.channel("stream:" + streamer_id);
      channel.join();

      channel
        .push("viewer:join", {})
        .receive("ok", (resp) => {
          startSubscribing(resp);
        });
    },

    unmount: () => {
      console.log('LiveStream Show unmounted');
    }
  });
};
