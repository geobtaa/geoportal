import consumer from "./consumer"

consumer.subscriptions.create({ channel: "ExportChannel" }, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log('Export Channel Connected');
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log('Export Channel Disconnected');
  },

  received(data) {
    console.log('Export Channel Received');
    console.log(data);

    if (data['progress']) {
      console.log(data['progress']);
    }

    if (data['actions']) {
      for (let index = 0; index < data.actions.length; ++index) {
        var fnstring = data.actions[index].method;
        var fn = window["GBLADMIN"][fnstring];
        if (typeof fn === "function") fn(data.actions[index].payload);
      }
    }
  }
});
