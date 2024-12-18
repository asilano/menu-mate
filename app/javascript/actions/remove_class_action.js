function removeClass() {
  this.targetElements.forEach(e => {
    this.classList.forEach(c => e.classList.remove(c));
  });
}

export default removeClass;
