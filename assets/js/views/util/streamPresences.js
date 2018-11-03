import {Presence} from 'phoenix';

export default (channel, presences, element) => {

  channel.on("presence_state", state => {
    presences = Presence.syncState(presences, state);
    element.innerHTML = Object.keys(presences).length;
  })

  channel.on("presence_diff", diff => {
    presences = Presence.syncDiff(presences, diff);
    element.innerHTML = Object.keys(presences).length;
  });

};
