import { Controller } from "@hotwired/stimulus"
import debounce from "src/debounce";

// Connects to data-controller="day-name-edit"
export default class extends Controller {
  static targets = ["updateForm", "name", "nameField", "submitButton", "reloadLink"];

  connect() {
    this.submit = debounce(this.submit, 200);
  }

  submit = () => {
    this.nameFieldTarget.value = this.nameTarget.innerText;
    this.updateFormTarget.requestSubmit(this.submitButtonTarget);
  }

  editDone() {
    this.reloadLinkTarget.click();
  }
}
