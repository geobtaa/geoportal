import { createCssNs } from 'css-ns';
/**
 * export ns - sets up css namespacing for everything to be `mirador-`
 */

var ns = function ns(className) {
  return createCssNs({
    namespace: 'mirador'
  })(className);
};

export default ns;