import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["initButton", "form"];

  start(e) {
    e.preventDefault();

    this.initButtonTarget.classList.toggle("not-in-flow", true);
    this.formTarget.classList.toggle("not-in-flow", false);
  }

  stop(e) {
    e.preventDefault();

    this.initButtonTarget.classList.toggle("not-in-flow", false);
    this.formTarget.classList.toggle("not-in-flow", true);
  }
}