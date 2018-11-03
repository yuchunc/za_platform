import socket from '../../socket';
import main from '../main';
import commentAction from '../util/comment';
import setViewerCount from '../util/streamPresences';

const stream_id = window.streamConfig.stream_id;
const streamer_id = window.streamConfig.streamer_id;
const user_id = window.streamConfig.user_id;

let followBtn = document.getElementById('viewer-follow-btn');
let viewerCountElem = document.getElementById('viewer-count');

const startSubscribing = (ot_config) => {
  const session = OT.initSession(ot_config.key, ot_config.session_id)

  session.on('streamCreated', function(event) {
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

      let streamChannel = socket.channel('stream:' + stream_id);
      let userChannel = socket.channel('user:' + user_id);

      streamChannel.join();
      userChannel.join();

      let presences = {};

      streamChannel
        .push('viewer:join', {})
        .receive('ok', (resp) => {
          startSubscribing(resp);
        });

      commentAction(streamChannel);
      setViewerCount(streamChannel, presences, viewerCountElem)

      if(followBtn !== null) {
        followBtn.addEventListener('click', event => {
          event.preventDefault();
          if(followBtn.classList.contains('following')) {
            userChannel
              .push('following:remove', {followee_id: streamer_id})
              .receive('ok', () => {
                followBtn.classList.remove('following');
                followBtn.innerHTML = '跟隨';
              });
          } else {
            if(user_id === "") {
              alert("請先從右上角登入");
            } else {
              userChannel
                .push('following:add', {followee_id: streamer_id})
                .receive('ok', () => {
                  followBtn.classList.add('following');
                  followBtn.innerHTML = '已跟隨';
                });
            };
          };
        });
      };
    },

    unmount: () => {
      console.log('LiveStream Show unmounted');
    }
  });
};
