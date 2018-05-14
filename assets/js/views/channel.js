import socket from '../socket';

const joinChannel = (otAction) => {
  const streamer_id = window.streamConfig.streamer_id

  let channel = socket.channel("stream:" + streamer_id).join()

  return channel.receive("ok", (msg) => {
    console.log("ping");
    otAction();
  }).receive("error", (reason) => {
    console.log("ws join failed", reason);
  });
}

export default () => {
  return {
    joinChannel
  }
}
