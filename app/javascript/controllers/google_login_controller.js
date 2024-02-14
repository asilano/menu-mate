import { Controller } from "@hotwired/stimulus"

function callback() {
  console.log("Callback!")
}

export default class extends Controller {
  static values = { clientId: String };
  static targets = [ "signIn" ]

  setup() {
    const google = globalThis.google
    google.accounts.id.initialize({
      client_id: this.clientIdValue,
      callback: callback,
      cancel_on_tap_outside: false,
    });
    google.accounts.id.renderButton(this.signInTarget, {
      theme: "outline",
      size: "large",
    }, [])
  }
}
