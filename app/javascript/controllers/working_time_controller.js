import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  connect() {
    this.interval = setInterval(() => {
      const workingTimeElement = document.querySelector(".working-time");
      if (workingTimeElement) {
        const updateLink = document.getElementById("update-working-time-link");
        updateLink.click();
      }
    }, 60000); // 1分ごとに更新
  }

  disconnect() {
    clearInterval(this.interval);
  }
}
