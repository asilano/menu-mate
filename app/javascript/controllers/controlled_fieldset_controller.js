import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="controlled-fieldset"
export default class extends Controller {
  static targets = [ "control", "destroyField", "controlledField" ];

  connect() {
    this.update();
  }

  update() {
    const enabled = this.controlTarget.checked;

    if (this.hasDestroyFieldTarget) {
      this.destroyFieldTarget.value = enabled ? 0 : 1;
    }

    this.controlledFieldTargets.forEach(field => {
      field.toggleAttribute("hidden", !enabled);
    })
  }
}
