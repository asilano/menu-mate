import { Controller } from "@hotwired/stimulus"
import debounce from "src/debounce"

// Connects to data-controller="lozenge-preview"
export default class extends Controller {
  static targets = ["preview"]
  static values = { styleUrl: String }

  connect() {
    this.colourChange = debounce(this.colourChange, 50)
  }

  nameChange(event) {
    this.previewTarget.textContent = event.target.value;
  }

  colourChange = async (event) => {
    const url = new URL(this.styleUrlValue)
    url.searchParams.append("colour", event.target.value)

    const response = await fetch(url)
    const style = await response.text()

    this.previewTarget.style = style
  }
}
