import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="main-menu"
export default class extends Controller {
  static targets = [ "menuLinks", "toggleButton" ];

  showHide(e) {
    e.preventDefault();
    this.menuLinksTarget.classList.toggle("hidden");
    this.toggleButtonTarget.classList.toggle("fa-bars");
    this.toggleButtonTarget.classList.toggle("fa-xmark");
  }
}
