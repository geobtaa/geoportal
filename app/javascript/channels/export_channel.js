import consumer from "./consumer"

export default consumer.subscriptions.create({ channel: "ExportChannel" }, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("GBL Admin - ExportChannel connected");
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
    console.log("GBL Admin - ExportChannel disconnected");
  },

  received(data) {
    console.log('GBL Admin - ExportChannel received!');
    console.log(data);

    if (data['progress']) {
      console.log('Progress:', data['progress']);
      const progressBar = document.querySelector('[data-export-progress]');
      if (progressBar) {
        progressBar.style.width = `${data['progress']}%`;
        progressBar.setAttribute('aria-valuenow', data['progress']);
        progressBar.textContent = `${data['progress']}%`;

        // When progress reaches 100%, show download link
        if (data['progress'] === 100) {
          const alertInfo = document.querySelector('.alert-info');
          if (alertInfo) {
            alertInfo.innerHTML = `
              <p class="mb-0">
                <i class="fas fa-check-circle me-2"></i>
                Your export is ready! 
                <a href="${data['download_url']}" class="btn btn-primary ms-3">
                  <i class="fas fa-download me-2"></i>
                  Download File
                </a>
              </p>
            `;
          }
        }
      }
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
