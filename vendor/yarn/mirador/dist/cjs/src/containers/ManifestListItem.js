"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _redux = require("redux");

var _reactRedux = require("react-redux");

var _reactI18next = require("react-i18next");

var _core = require("@material-ui/core");

var _withPlugins = require("../extend/withPlugins");

var _selectors = require("../state/selectors");

var actions = _interopRequireWildcard(require("../state/actions"));

var _ManifestListItem = require("../components/ManifestListItem");

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { "default": obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj["default"] = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

/** */
var mapStateToProps = function mapStateToProps(state, _ref) {
  var manifestId = _ref.manifestId;
  return {
    active: (0, _selectors.getWindowManifests)(state).includes(manifestId),
    error: (0, _selectors.getManifest)(state, {
      manifestId: manifestId
    }).error,
    isFetching: (0, _selectors.getManifest)(state, {
      manifestId: manifestId
    }).isFetching,
    manifestLogo: (0, _selectors.getManifestLogo)(state, {
      manifestId: manifestId
    }),
    provider: (0, _selectors.getManifest)(state, {
      manifestId: manifestId
    }).provider || (0, _selectors.getManifestProvider)(state, {
      manifestId: manifestId
    }),
    ready: !!(0, _selectors.getManifest)(state, {
      manifestId: manifestId
    }).json,
    size: (0, _selectors.getManifestCanvases)(state, {
      manifestId: manifestId
    }).length,
    thumbnail: (0, _selectors.getManifestThumbnail)(state, {
      manifestId: manifestId
    }),
    title: (0, _selectors.getManifestTitle)(state, {
      manifestId: manifestId
    })
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof ManifestListItem
 * @private
 */


var mapDispatchToProps = {
  addWindow: actions.addWindow,
  fetchManifest: actions.fetchManifest
};
/**
 *
 * @param theme
 * @returns {{root: {}, label: {textAlign: string, textTransform: string}}}
 */

var styles = function styles(theme) {
  return {
    active: {},
    buttonGrid: {
      '&:hover': {
        backgroundColor: theme.palette.action.hover
      }
    },
    label: {
      textAlign: 'left',
      textTransform: 'initial'
    },
    logo: {
      height: '2.5rem',
      paddingRight: 8
    },
    placeholder: {
      backgroundColor: theme.palette.grey[300]
    },
    root: _objectSpread({}, theme.mixins.gutters(), {
      '&$active': {
        borderLeft: "4px solid ".concat(theme.palette.primary.main)
      },
      borderLeft: '4px solid transparent'
    })
  };
};

var enhance = (0, _redux.compose)((0, _reactI18next.withTranslation)(), (0, _core.withStyles)(styles), (0, _reactRedux.connect)(mapStateToProps, mapDispatchToProps), (0, _withPlugins.withPlugins)('ManifestListItem'));

var _default = enhance(_ManifestListItem.ManifestListItem);

exports["default"] = _default;