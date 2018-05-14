import channel from '../channel';
import main from '../main';

const startSubscribing = () => {
  const config = window.streamConfig;
  const session = OT.initSession(config.key, config.sessionId)

  session.on("streamCreated", function(event) {
    console.log(event, "event");
    bar = session.subscribe(event.stream, 'subscriber', {
      insertMode: 'append',
      width: '100%',
      height: '100%'
    }, main.handleError);
  })

  session.connect(config.token, main.handleError)
  session.subscribe
};

export default () => {
  return Object.assign(main(), {
    mount: () => {
      console.log('LiveStream Show mounted');
      channel().joinChannel(startSubscribing);
    },

    unmount: () => {
      console.log('LiveStream Show unmounted');
    }
  });
};
