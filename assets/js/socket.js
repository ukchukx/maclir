// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket, Presence} from "phoenix";



let presences = {};

const socket = new Socket("/socket", {
	params: {token: window.userToken},
  logger: (kind, msg, data) => {
    console.log(`${kind} >> ${msg}`, data);
  }
});

socket.connect();
socket.onError(ev => console.error('socket error', ev));
socket.onClose(ev => console.warn('socket closed', ev));


// When server & client clocks are out of sync, we might sometimes get
// 'in a few seconds', which is a weird message for a past event
moment.fn.fromNowOrNow = function (a) {
  if (Math.abs(moment().diff(this)) < 5000) { // 5000 milliseconds
      return 'a few seconds ago';
  }
  return this.fromNow(a);
}

const renderPresences = (presences) => {
  const lastSeenElems = [...document.querySelectorAll('small.last-seen')];
  Presence.list(presences, (user, {metas}) => {
    return {
      user,
      onlineAt: moment(new Date(metas[0].online_at)).fromNowOrNow()
    }
  })
  .map(({user, onlineAt}) => {
  	if (!lastSeenElems.length) return false;
  	const elem = lastSeenElems.find(el => el.dataset.lastSeenUuid === user);
  	if (!elem) return false;
  	elem.innerHTML = `Last seen: ${onlineAt}`;
  	return true;
  }); 
};


const handlePresenceDiff = diff => {
  presences = Presence.syncDiff(presences, diff);
  renderPresences(presences);
};

const handlePresenceState = state => {
  presences = Presence.syncState(presences, state);
  renderPresences(presences);
};

const handlePresenceUpdate = update => {
	presences = Object.assign(presences, update);
  renderPresences(presences);
};

// Now that you are connected, you can join channels with a topic:
const channel = socket.channel(`user:${window.userUUID}`, {});

channel.join()
  .receive("ok", resp => { console.log("Joined", resp) })
  .receive("error", resp => { console.warn("Unable to join", resp) });

channel.on("presence_state", handlePresenceState);
channel.on("presence_diff", handlePresenceDiff);


const updatePresenceInterval = 60000; // 1 minute
const updatePresence = () => {
	channel.push("presence:update", {});
	setTimeout(updatePresence, updatePresenceInterval);
};
setTimeout(updatePresence, updatePresenceInterval);


const presenceRenderingInterval = 30000; // half minute
const handlePresenceRendering = () => {
	renderPresences(presences);
	setTimeout(handlePresenceRendering, presenceRenderingInterval);
}
setTimeout(handlePresenceRendering, presenceRenderingInterval);


// Handle messages that are sent to friends' topics
socket.onMessage(({topic, event, payload}) => {
	if (/^user_presence/.test(topic)) {
	  if (event == "presence_diff") {
	    handlePresenceDiff(payload);
	  } else if (event == "presence_state") {
	    handlePresenceState(payload);
	  }else if (event == "presence_update") {
	    handlePresenceUpdate(payload);
	  }		
	}
});


export default socket;
