import socket from '../socket';

const createChannel = () => {
  const streamer_id = window.streamConfig.streamer_id;

  return socket.channel("stream:" + streamer_id);
}

const joinChannel = (channel) => {
  return channel.join().receive("ok", (resp) => {
    console.log("ws joined", resp);
  }).receive("error", (msg) => {
    console.log("ws failed", msg);
  });
}

export {createChannel, joinChannel};
