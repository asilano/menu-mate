import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="lozenge-preview"
export default class extends Controller {
  static targets = ["preview"]

  connect() {
    console.log("Preview connected")
  }

  nameChange(event) {
    this.previewTarget.textContent = event.target.value;
  }
}
