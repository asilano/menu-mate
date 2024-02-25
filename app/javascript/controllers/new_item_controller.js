import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="new-item"
export default class extends Controller {
  static targets = [ "dialog" ];

  showDialog() {
    this.dialogTarget.showModal();
  }

  closeDialog() {
    this.dialogTarget.close();
  }
}
