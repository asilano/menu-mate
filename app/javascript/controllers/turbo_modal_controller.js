import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="turbo-modal"
export default class extends Controller {
  static targets = ["modalInner"]
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
    if (e && this.modalInnerTarget.contains(e.target)) {
      return
    }
    this.hideModal()
  }
}
