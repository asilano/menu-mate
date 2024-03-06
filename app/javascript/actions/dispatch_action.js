function dispatch() {
  const eventName = this.getAttribute("name");
  let detail = {};
  if (this.hasAttribute("detail")) {
    detail = JSON.parse(this.getAttribute("detail"));
  }

  var target = this;
  if (this.hasAttribute("target")) {
    target = document.getElementById(this.getAttribute("target"));
  }

  target.dispatchEvent(
    new CustomEvent(
      eventName, { bubbles: true, cancellable: false, detail },
    ),
  );
}

export default dispatch;
