import main from '../main';

import socket from "./../../socket"

let channel = socket.channel("call", {})

channel.join()
  .receive("ok", () => { console.log("Successfully joined call channel")})
  .receive("error", () => { console.log("Unable to join") })

let localStream, peerConnection;
let localVideo = document.getElementById("localVideo")
let remoteVideo = document.getElementById("remoteVideo")
let connectButton = document.getElementById("connect")
let callButton = document.getElementById("call")
let hangupButton = document.getElementById("hangup")

hangupButton.disabled = true;
callButton.disabled = true;
connectButton.onclick = connect;
callButton.onclick = call;
hangupButton.onclick = hangup;

function connect() {
  console.log("Requesting local stream");
  navigator.getUserMedia({audio: true, video: true}, gotStream, error => {
    console.log("getUserMedia error : ", error);
  })
}

function gotStream(stream) {
  console.log("Received local stream");
  localVideo.src = URL.createObjectURL(stream);
  localStream = stream;
  setupPeerConnection();
}

function setupPeerConnection() {
  connectButton.disabled = true;
  callButton.disabled = false;
  hangupButton.disabled = false;
  console.log("waiting for call");

  let servers = {
    "iceServers": [{
      // "url": "stun:stun.l.google.com:19302"
      "url": "stun:13.229.116.138:3478"
    }]
  };

  peerConnection = new RTCPeerConnection(servers);
  console.log("Created local peer connection");
  peerConnection.onicecandidate = gotLocalIceCandidate;
  peerConnection.onaddstream = gotRemoteStream;
  peerConnection.addStream(localStream);
  console.log("Added localstream to localPeerConnection");
}

function call() {
  callButton.disabled = true;
  console.log("Starting call");
  peerConnection.createOffer(gotLocalDescription, handleError);
}

function gotLocalDescription(description) {
  peerConnection.setLocalDescription(description, () => {
    channel.push("message", {body: JSON.stringify({
      "sdp" : peerConnection.localDescription
    })});
  }, handleError);

  console.log("Offer from localPeerConnection: \n " + description.sdp);
}

function gotRemoteDescription(description) {
  console.log("Answer from remotePeerConnection: \n", description.sdp);
  peerConnection.setRemoteDescription(new RTCSessionDescription(description));
  peerConnection.createAnswer(gotLocalDescription, handleError);
}

function gotRemoteStream(event) {
  removeVideo.src = URL.createObjectURL(event.stream);
  console.log("Received remote stream");
}

function gotLocalIceCandidate(event) {
  if (event.candidate) {
    console.log("Local ICE candidate: \n" + event.candidate.candidate);
    channel.push("message", {body: JSON.stringify({
      "candidate": event.candidate
    })});
  }
}

function gotRemoteIceCandidate(event) {
  callButton.disabled = true;
  if (event.candidate) {
    peerConnection.addIceCandidate(new RTCIceCandidate(event.candidate));
    console.log("Remote ICE candidate: \n"+ event.candidate.candidate);
  }
}

channel.on("message", payload => {
  let message = JSON.parse(payload.body);
  if (message.sdp) {
    gotRemoteDescription(message);
  } else {
    gotRemoteIceCandidate(message);
  }
})

function hangup() {
  console.log("Ending call");
  peerConnection.close();
  localVideo.src = null;
  peerConnection = null;
  hangupButton.disabled = true;
  connectButton.disabled = false;
  callButton.disabled = true;
}

export default () => {
  return Object.assign(main(), {
    mount: () => {
      console.log("ping");
    },
    unmount: () => {
      console.log("pong");
    }
  });
};
