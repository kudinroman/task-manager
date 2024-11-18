import { Controller } from '@hotwired/stimulus';

export default class extends Controller {
  static targets = ['text', 'tooltip'];

  connect() {
    this.checkOverflow();
  }

  checkOverflow() {
    if (this.textTarget.scrollWidth > this.textTarget.clientWidth) {
      this.tooltipTarget.style.visibility = 'visible';
    } else {
      this.tooltipTarget.style.visibility = 'hidden';
    }
  }
}
