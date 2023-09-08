'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var stimulus = require('stimulus');

function _defineProperty(obj, key, value) {
  if (key in obj) {
    Object.defineProperty(obj, key, {
      value: value,
      enumerable: true,
      configurable: true,
      writable: true
    });
  } else {
    obj[key] = value;
  }

  return obj;
}
class _class extends stimulus.Controller {
  initialize() {
    this.scroll = this.scroll.bind(this);
  }

  connect() {
    this.element.addEventListener('click', this.scroll);
    this.offset = this.offsetValue || this.defaultOptions.offset || 10;
    this.behavior = this.behaviorValue || this.defaultOptions.behavior || 'smooth';
  }

  disconnect() {
    this.element.removeEventListener('click', this.scroll);
  }

  scroll(event) {
    event.preventDefault();
    const id = this.element.hash.replace(/^#/, '');
    const target = document.getElementById(id);

    if (!target) {
      console.warn(`[stimulus-scroll-to] The element with the id: "${id}" does not exist on the page.`);
      return;
    }

    const elementPosition = target.getBoundingClientRect().top + window.pageYOffset;
    const offsetPosition = elementPosition - this.offset;
    window.scrollTo({
      top: offsetPosition,
      behavior: this.behavior
    });
  }

  get defaultOptions() {
    return {};
  }

}

_defineProperty(_class, "values", {
  offset: Number,
  behavior: String
});

exports.default = _class;
//# sourceMappingURL=index.js.map
