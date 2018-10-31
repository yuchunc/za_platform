import socket from '../../socket';
import main from '../main';
import commentAction from '../util/comment';

const stream_id = window.streamConfig.stream_id;

let followBtn = document.getElementById('viewer-follow-btn');

const startSubscribing = (ot_config) => {
  const session = OT.initSession(ot_config.key, ot_config.session_id)

  session.on('streamCreated', function(event) {
    console.log('event', event);
    session.subscribe(event.stream, 'stream-view', {
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

      let channel = socket.channel('stream:' + stream_id);
      channel.join();

      channel
        .push('viewer:join', {})
        .receive('ok', (resp) => {
          startSubscribing(resp);
        });

      commentAction(channel);

      followBtn.addEventListener('click', () => {
        if(followBtn.classList.contains('following')) {
          channel
            .push('viewer:stop_follow')
            .receive('ok', () => {
              followBtn.classList.remove('following');
              followBtn.innerValue = '跟隨';
            });
        } else {
          channel
            .push('viewer:start_following')
            .receive('ok', () => {
              followBtn.classList.add('following');
              followBtn.innerValue = '已跟隨';
            });
        };
      });
    },

    unmount: () => {
      console.log('LiveStream Show unmounted');
    }
  });
};
