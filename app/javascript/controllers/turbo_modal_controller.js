import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  hideModal() {
    this.element.parentElement.removeAttribute("src");
    this.element.remove()
  }

  handleKeypress(e) {
    if (e.code == "Escape") {
      this.hideModal()
    }
  }

  handleClick(e) {
    if (e && this.element.contains(e.target)) {
      return
    }
    this.hideModal()
  }
}
