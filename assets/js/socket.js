// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/web/endpoint.ex":
import {Socket, Presence} from "phoenix";

// When server & client clocks are out of sync, we might sometimes get
// 'in a few seconds', which is a weird message for a past event
moment.fn.fromNowOrNow = function (a) {
  if (Math.abs(moment().diff(this)) < 5000) { // 5000 milliseconds
      return 'a few seconds ago';
  }
  return this.fromNow(a);
}

class SocketHandler {
	constructor() {
		this.updatePresenceInterval = 60000; // 1 minute
		this.presenceRenderingInterval = 30000; // half minute
		this.presences = {};

		this.socket = new Socket("/socket", {
			params: {token: window.userToken},
		  logger: (kind, msg, data) => {
		  	if (window.debug) {
		  		console.log('kind and msg', kind, msg);
		  		console.log('data', data);
		  	}
		  }
		});

		this.socket.connect();
		this.socket.onError(ev => console.error('socket error', ev));
		this.socket.onClose(ev => console.warn('socket closed', ev));
		// Handle messages that are sent to friends' topics
		this.socket.onMessage(({topic, event, payload}) => {
			if (/^user_presence/.test(topic)) {
			  if (event == "presence_diff") {
			    this.handlePresenceDiff(payload);
			  } else if (event == "presence_state") {
			    this.handlePresenceState(payload);
			  } else if (event == "presence_update") {
			    this.handlePresenceUpdate(payload);
			  } else if (event == "location_update") {
			    this.handleLocationUpdate(payload);
			  } else if (event == "friend_added") {
			    this.handleFriendAdded(payload);
			  }	else if (event == "friend_removed") {
			    this.handleFriendRemoved(payload);
			  }	else if (event == "friend_request_received") {
			    this.handleFriendRequestReceived(payload);
			  }	else if (event == "friend_request_rejected") {
			    this.handleFriendRequestRejected(payload);
			  }	else if (event == "friend_request_cancelled") {
			    this.handleFriendRequestCancelled(payload);
			  }	
			}
		});


		this.channel = this.socket.channel(`user:${window.userUUID}`, {});
		this.channel.join()
		  .receive("ok", resp => { console.log("Joined", resp) })
		  .receive("error", resp => { console.warn("Unable to join", resp) });

		this.channel.on("presence_state", this.handlePresenceState.bind(this));
		this.channel.on("presence_diff", this.handlePresenceDiff.bind(this));
		this.channel.on("friend_added", this.handleFriendAdded.bind(this));
		this.channel.on("friend_removed", this.handleFriendRemoved.bind(this));
		this.channel.on("friend_request_received", this.handleFriendRequestReceived.bind(this));
		this.channel.on("friend_request_rejected", this.handleFriendRequestRejected.bind(this));
		this.channel.on("friend_request_cancelled", this.handleFriendRequestCancelled.bind(this));

		this.lastSeenElems = [...document.querySelectorAll('small.last-seen')];
		this.registerUpdaters();
	}

	setMapHandler(mapHandler) {
		this.mapHandler = mapHandler;
	}

	pushLocationChange({ id, latitude, longitude, username }) {
		if (latitude && longitude) this.channel.push("location:update", { id, latitude, longitude, username });
	}

	updatePresence() {
		this.channel.push("presence:update", {});
		setTimeout(this.updatePresence.bind(this), this.updatePresenceInterval);
	}

	handlePresenceRendering() {
		this.renderPresences();
		setTimeout(this.handlePresenceRendering.bind(this), this.presenceRenderingInterval);
	}

	registerUpdaters() {
		setTimeout(this.updatePresence.bind(this), this.updatePresenceInterval);
		setTimeout(this.handlePresenceRendering.bind(this), this.presenceRenderingInterval);
	}

	renderPresences() {
	  Presence.list(this.presences, (user, {metas}) => {
	    return {
	      user,
	      onlineAt: moment(new Date(metas[0].online_at)).fromNowOrNow()
	    }
	  })
	  .map(({user, onlineAt}) => {
	  	if (!this.lastSeenElems.length) return false;
	  	const elem = this.lastSeenElems.find(el => el.dataset.lastSeenUuid === user);
	  	if (!elem) return false;
	  	elem.innerHTML = `Last seen: ${onlineAt}`;
	  	return true;
	  }); 
	}

	handlePresenceDiff(diff) {
	  this.presences = Presence.syncDiff(this.presences, diff);
	  this.renderPresences();
	}

	handlePresenceState(state) {
	  this.presences = Presence.syncState(this.presences, state);
	  this.renderPresences();
	}

	handlePresenceUpdate(update) {
		this.presences = Object.assign(this.presences, update);
	  this.renderPresences();
	}

	handleLocationUpdate({ id, latitude, longitude, username }) {
		if (latitude && longitude) this.mapHandler.setLocationFor({ id, latitude, longitude, username });
	}

	handleFriendAdded(payload) {
		
	}

	handleFriendRemoved(payload) {
		
	}

	handleFriendRequestReceived(payload) {
		
	}

	handleFriendRequestRejected(payload) {
		
	}

	handleFriendRequestCancelled(payload) {
		
	}
}


export default SocketHandler;
