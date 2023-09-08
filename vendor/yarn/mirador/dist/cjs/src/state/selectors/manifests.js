"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports.getManifest = getManifest;
exports.getManifestThumbnail = getManifestThumbnail;
exports.getDestructuredMetadata = getDestructuredMetadata;
exports.getManifestStartCanvas = getManifestStartCanvas;
exports.getManifestTreeStructure = exports.getManifestAutocompleteService = exports.getManifestSearchService = exports.getManifestViewingDirection = exports.getManifestViewingHint = exports.getMetadataLocales = exports.getManifestMetadata = exports.getManifestUrl = exports.getManifestDescription = exports.getManifestTitle = exports.getManifestCanvases = exports.getRights = exports.getRequiredStatement = exports.getManifestRelatedContent = exports.getManifestRenderings = exports.getManifestHomepage = exports.getManifestProvider = exports.getManifestLogo = exports.getManifestLocale = exports.getManifestoInstance = void 0;

var _reselect = require("reselect");

var _reReselect = _interopRequireDefault(require("re-reselect"));

var _LanguageMap = require("manifesto.js/dist-esmodule/LanguageMap");

var _Utils = require("manifesto.js/dist-esmodule/Utils");

var _ManifestoCanvas = _interopRequireDefault(require("../../lib/ManifestoCanvas"));

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { "default": obj }; }

function _toConsumableArray(arr) { return _arrayWithoutHoles(arr) || _iterableToArray(arr) || _unsupportedIterableToArray(arr) || _nonIterableSpread(); }

function _nonIterableSpread() { throw new TypeError("Invalid attempt to spread non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }

function _unsupportedIterableToArray(o, minLen) { if (!o) return; if (typeof o === "string") return _arrayLikeToArray(o, minLen); var n = Object.prototype.toString.call(o).slice(8, -1); if (n === "Object" && o.constructor) n = o.constructor.name; if (n === "Map" || n === "Set") return Array.from(n); if (n === "Arguments" || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(n)) return _arrayLikeToArray(o, minLen); }

function _iterableToArray(iter) { if (typeof Symbol !== "undefined" && Symbol.iterator in Object(iter)) return Array.from(iter); }

function _arrayWithoutHoles(arr) { if (Array.isArray(arr)) return _arrayLikeToArray(arr); }

function _arrayLikeToArray(arr, len) { if (len == null || len > arr.length) len = arr.length; for (var i = 0, arr2 = new Array(len); i < len; i++) { arr2[i] = arr[i]; } return arr2; }

/** */
function createManifestoInstance(json, locale) {
  if (!json) return undefined;
  return _Utils.Utils.parseManifest(json, locale ? {
    locale: locale
  } : undefined);
}
/** Get the relevant manifest information */


function getManifest(state, _ref) {
  var manifestId = _ref.manifestId,
      windowId = _ref.windowId;
  return state.manifests && state.manifests[manifestId || windowId && state.windows && state.windows[windowId] && state.windows[windowId].manifestId];
}
/** Instantiate a manifesto instance */


var getManifestoInstance = (0, _reReselect["default"])(getManifest, getLocale, function (manifest, locale) {
  return manifest && createManifestoInstance(manifest.json, locale);
})(function (state, props) {
  return [props.manifestId, props.windowId, state.companionWindows && state.companionWindows[props.companionWindowId] && state.companionWindows[props.companionWindowId].locale || state.config && state.config.language].join(' - ');
} // Cache key consisting of manifestId, windowId, and locale
);
exports.getManifestoInstance = getManifestoInstance;
var getManifestLocale = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  return manifest && manifest.options && manifest.options.locale && manifest.options.locale.replace(/-.*$/, '');
});
/** */

exports.getManifestLocale = getManifestLocale;

function getProperty(property) {
  return (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
    return manifest && manifest.getProperty(property);
  });
}
/** */


function getLocale(state, _ref2) {
  var companionWindowId = _ref2.companionWindowId;
  return companionWindowId && state.companionWindows[companionWindowId] && state.companionWindows[companionWindowId].locale || state.config && state.config.language;
}
/**
 * Get the logo for a manifest
 * @param {object} state
 * @param {object} props
 * @param {string} props.manifestId
 * @param {string} props.windowId
 * @return {String|null}
 */


var getManifestLogo = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  return manifest && manifest.getLogo();
});
/**
* Return the IIIF v3 provider of a manifest or null
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {String|null}
*/

exports.getManifestLogo = getManifestLogo;
var getManifestProvider = (0, _reselect.createSelector)([getProperty('provider'), getManifestLocale], function (provider, locale) {
  return provider && provider[0].label && _LanguageMap.LanguageMap.parse(provider[0].label, locale).map(function (label) {
    return label.value;
  })[0];
});
/**
 */

exports.getManifestProvider = getManifestProvider;

function asArray(value) {
  if (!Array.isArray(value)) {
    return [value];
  }

  return value;
}
/**
* Return the IIIF v3 homepage of a manifest or null
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {String|null}
*/


var getManifestHomepage = (0, _reselect.createSelector)([getProperty('homepage'), getManifestLocale], function (homepages, locale) {
  return homepages && asArray(homepages).map(function (homepage) {
    return {
      label: _LanguageMap.LanguageMap.parse(homepage.label, locale).map(function (label) {
        return label.value;
      })[0],
      value: homepage.id || homepage['@id']
    };
  });
});
/**
* Return the IIIF v3 renderings of a manifest or null
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {String|null}
*/

exports.getManifestHomepage = getManifestHomepage;
var getManifestRenderings = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  return manifest && manifest.getRenderings().map(function (rendering) {
    return {
      label: rendering.getLabel().map(function (label) {
        return label.value;
      })[0],
      value: rendering.id
    };
  });
});
/**
* Return the IIIF v2/v3 seeAlso data from a manifest or null
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {String|null}
*/

exports.getManifestRenderings = getManifestRenderings;
var getManifestRelatedContent = (0, _reselect.createSelector)([getProperty('seeAlso'), getManifestLocale], function (seeAlso, locale) {
  return seeAlso && asArray(seeAlso).map(function (related) {
    return {
      format: related.format,
      label: _LanguageMap.LanguageMap.parse(related.label, locale).map(function (label) {
        return label.value;
      })[0],
      value: related.id || related['@id']
    };
  });
});
/**
* Return the IIIF requiredStatement (v3) or attribution (v2) data from a manifest or null
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {String|null}
*/

exports.getManifestRelatedContent = getManifestRelatedContent;
var getRequiredStatement = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  return manifest && asArray(manifest.getRequiredStatement()).filter(function (l) {
    return l.getValue();
  }).map(function (labelValuePair) {
    return {
      label: labelValuePair.getLabel(),
      value: labelValuePair.getValue()
    };
  });
});
/**
* Return the IIIF v2 rights (v3) or license (v2) data from a manifest or null
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {String|null}
*/

exports.getRequiredStatement = getRequiredStatement;
var getRights = (0, _reselect.createSelector)([getProperty('rights'), getProperty('license'), getManifestLocale], function (rights, license, locale) {
  var data = rights || license;
  return asArray(_LanguageMap.LanguageMap.parse(data, locale).map(function (label) {
    return label.value;
  }));
});
/**
* Return the supplied thumbnail for a manifest or null
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {String|null}
*/

exports.getRights = getRights;

function getManifestThumbnail(state, props) {
  /** */
  function getTopLevelManifestThumbnail() {
    var manifest = getManifestoInstance(state, props);
    return manifest && manifest.getThumbnail() && manifest.getThumbnail().id;
  }
  /** */


  function getFirstCanvasThumbnail() {
    var canvases = getManifestCanvases(state, props);
    return canvases.length > 0 && canvases[0].getThumbnail() && canvases[0].getThumbnail().id;
  }
  /** */


  function generateThumbnailFromFirstCanvas() {
    var canvases = getManifestCanvases(state, props);
    if (canvases.length === 0) return null;
    var manifestoCanvas = new _ManifestoCanvas["default"](canvases[0]);
    return manifestoCanvas.thumbnail(null, 80);
  }

  return getTopLevelManifestThumbnail() || getFirstCanvasThumbnail() || generateThumbnailFromFirstCanvas();
}
/**
* Return the logo of a manifest or null
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {String|null}
*/


var getManifestCanvases = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  if (!manifest) {
    return [];
  }

  if (!manifest.getSequences || !manifest.getSequences()[0]) {
    return [];
  }

  return manifest.getSequences()[0].getCanvases();
});
/**
* Return manifest title
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {String}
*/

exports.getManifestCanvases = getManifestCanvases;
var getManifestTitle = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  return manifest && manifest.getLabel().map(function (label) {
    return label.value;
  })[0];
});
/**
* Return manifest description
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {String}
*/

exports.getManifestTitle = getManifestTitle;
var getManifestDescription = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  return manifest && manifest.getDescription().map(function (label) {
    return label.value;
  })[0];
});
/**
* Return manifest title
* @param {object} state
* @param {object} props
* @param {string} props.manifestId
* @param {string} props.windowId
* @return {String}
*/

exports.getManifestDescription = getManifestDescription;
var getManifestUrl = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  return manifest && manifest.id;
});
/**
* Return metadata in a label / value structure
* This is a potential seam for pulling the i18n locale from
* state and plucking out the appropriate language.
* For now we're just getting the first.
* @param {object} Manifesto IIIF Resource (e.g. canvas, manifest)
* @return {Array[Object]}
*/

exports.getManifestUrl = getManifestUrl;

function getDestructuredMetadata(iiifResource) {
  return iiifResource && iiifResource.getMetadata().map(function (labelValuePair) {
    return {
      label: labelValuePair.getLabel(),
      value: labelValuePair.getValue()
    };
  });
}
/**
 * Return manifest metadata in a label / value structure
 * @param {object} state
 * @param {object} props
 * @param {string} props.manifestId
 * @param {string} props.windowId
 * @return {Array[Object]}
 */


var getManifestMetadata = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  return manifest && getDestructuredMetadata(manifest);
});
/** */

exports.getManifestMetadata = getManifestMetadata;

function getLocalesForStructure(item) {
  var languages = [];

  if (Array.isArray(item)) {
    languages.push.apply(languages, _toConsumableArray(item.filter(function (i) {
      return typeof i === 'object' && i['@language'];
    }).map(function (i) {
      return i['@language'];
    })));
  } else if (typeof item === 'object') {
    if (item['@language']) languages.push(item['@language']);
  }

  return languages;
}
/** */


function getLocales(resource) {
  if (!resource) return [];
  var metadata = resource.getProperty('metadata') || [];
  var languages = {};

  for (var i = 0; i < metadata.length; i += 1) {
    var item = metadata[i];
    getLocalesForStructure(item.label).forEach(function (l) {
      languages[l] = true;
    });
    getLocalesForStructure(item.value).forEach(function (l) {
      languages[l] = true;
    });
  }

  return Object.keys(languages);
}

var getMetadataLocales = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  return getLocales(manifest);
});
/**
 * Returns the starting canvas specified in the manifest
 * @param {object} manifest manifesto instance
 * @param {number} canvasIndexFromState
 * @return {Canvas}
 */

exports.getMetadataLocales = getMetadataLocales;

function getManifestStartCanvas(json, canvasIndexFromState) {
  if (!json) return {};
  var manifest = createManifestoInstance(json);
  if (!manifest) return {};

  if (canvasIndexFromState !== undefined) {
    return manifest.getSequences()[0].getCanvasByIndex(canvasIndexFromState);
  }

  var canvasId; // IIIF v2

  canvasId = manifest.getSequences()[0].getProperty('startCanvas');

  if (!canvasId) {
    // IIIF v3
    var start = manifest.getProperty('start') || manifest.getSequences()[0].getProperty('start');
    canvasId = start && (start.id || start.source);
  }

  return canvasId && manifest.getSequences()[0].getCanvasById(canvasId) || {};
}
/**
 * Returns the viewing hint for the first sequence in the manifest or the manifest
 * @param {object} state
 * @param {object} props
 * @param {string} props.manifestId
 * @param {string} props.windowId
 * @return {Number}
 */


var getManifestViewingHint = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  if (!manifest) return null;
  var viewingHint = manifest.getSequences()[0] && manifest.getSequences()[0].getViewingHint() || manifest.getViewingHint();
  if (viewingHint) return viewingHint;
  return null;
});
exports.getManifestViewingHint = getManifestViewingHint;
var getManifestViewingDirection = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  if (!manifest) return null;
  var viewingDirection = manifest.getSequences()[0].getViewingDirection() || manifest.getViewingDirection();
  if (viewingDirection) return viewingDirection;
  return null;
});
/** */

exports.getManifestViewingDirection = getManifestViewingDirection;
var getManifestSearchService = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  if (!manifest) return null;
  var searchService = manifest.getService('http://iiif.io/api/search/0/search') || manifest.getService('http://iiif.io/api/search/1/search');
  if (searchService) return searchService;
  return null;
});
/** */

exports.getManifestSearchService = getManifestSearchService;
var getManifestAutocompleteService = (0, _reselect.createSelector)([getManifestSearchService], function (searchService) {
  var autocompleteService = searchService && (searchService.getService('http://iiif.io/api/search/0/autocomplete') || searchService.getService('http://iiif.io/api/search/1/autocomplete'));
  return autocompleteService && autocompleteService;
});
/** */

exports.getManifestAutocompleteService = getManifestAutocompleteService;
var getManifestTreeStructure = (0, _reselect.createSelector)([getManifestoInstance], function (manifest) {
  if (!manifest) return null;
  return manifest.getDefaultTree();
});
exports.getManifestTreeStructure = getManifestTreeStructure;