// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="results">
//   <h1 data-target="results.selectAll"></h1>
// </div>

import { Application } from "stimulus"
import ScrollTo from "stimulus-scroll-to"

export default class extends ScrollTo {
  connect() {
  }

  // You can set default options in this getter for all your anchors.
  get defaultOptions () {
    return {
      behavior: 'smooth'
    }
  }
}

const application = Application.start()
application.register("scroll-to", ScrollTo)
