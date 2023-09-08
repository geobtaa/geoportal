"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _redux = require("redux");

var _reactRedux = require("react-redux");

var _reactI18next = require("react-i18next");

var _core = require("@material-ui/core");

var _colorManipulator = require("@material-ui/core/styles/colorManipulator");

var _withPlugins = require("../extend/withPlugins");

var actions = _interopRequireWildcard(require("../state/actions"));

var _selectors = require("../state/selectors");

var _WindowAuthenticationControl = require("../components/WindowAuthenticationControl");

function _getRequireWildcardCache() { if (typeof WeakMap !== "function") return null; var cache = new WeakMap(); _getRequireWildcardCache = function _getRequireWildcardCache() { return cache; }; return cache; }

function _interopRequireWildcard(obj) { if (obj && obj.__esModule) { return obj; } if (obj === null || typeof obj !== "object" && typeof obj !== "function") { return { "default": obj }; } var cache = _getRequireWildcardCache(); if (cache && cache.has(obj)) { return cache.get(obj); } var newObj = {}; var hasPropertyDescriptor = Object.defineProperty && Object.getOwnPropertyDescriptor; for (var key in obj) { if (Object.prototype.hasOwnProperty.call(obj, key)) { var desc = hasPropertyDescriptor ? Object.getOwnPropertyDescriptor(obj, key) : null; if (desc && (desc.get || desc.set)) { Object.defineProperty(newObj, key, desc); } else { newObj[key] = obj[key]; } } } newObj["default"] = obj; if (cache) { cache.set(obj, newObj); } return newObj; }

/**
 * mapStateToProps - to hook up connect
 * @memberof App
 * @private
 */
var mapStateToProps = function mapStateToProps(state, _ref) {
  var windowId = _ref.windowId;
  var canvasId = ((0, _selectors.getCurrentCanvas)(state, {
    windowId: windowId
  }) || {}).id;
  var service = (0, _selectors.selectCanvasAuthService)(state, {
    canvasId: canvasId,
    windowId: windowId
  });
  var infoResponse = (0, _selectors.selectInfoResponse)(state, {
    canvasId: canvasId,
    windowId: windowId
  }) || {};
  return {
    confirmLabel: service && service.getConfirmLabel(),
    degraded: infoResponse.degraded,
    description: service && service.getDescription(),
    failureDescription: service && service.getFailureDescription(),
    failureHeader: service && service.getFailureHeader(),
    header: service && service.getHeader(),
    infoId: infoResponse.id,
    label: service && service.getLabel()[0].value,
    profile: service && service.getProfile(),
    serviceId: service && service.id,
    status: service && (0, _selectors.selectAuthStatus)(state, service)
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof App
 * @private
 */


var mapDispatchToProps = {
  handleAuthInteraction: actions.addAuthenticationRequest
};
/**
 * @param theme
 * @returns {{typographyBody: {flexGrow: number, fontSize: number|string},
 * windowTopBarStyle: {minHeight: number, paddingLeft: number, backgroundColor: string}}}
 */

var styles = function styles(theme) {
  return {
    buttonInvert: {
      '&:hover': {
        backgroundColor: (0, _colorManipulator.fade)(theme.palette.secondary.contrastText, 1 - theme.palette.action.hoverOpacity)
      },
      backgroundColor: theme.palette.secondary.contrastText
    },
    expanded: {
      paddingLeft: theme.spacing(),
      paddingRight: theme.spacing()
    },
    failure: {
      backgroundColor: theme.palette.error.dark
    },
    fauxButton: {
      marginLeft: theme.spacing(2.5)
    },
    icon: {
      marginRight: theme.spacing(1.5),
      verticalAlign: 'text-bottom'
    },
    label: {
      lineHeight: 2.25
    },
    paper: {
      backgroundColor: theme.palette.secondary.main,
      color: theme.palette.secondary.contrastText,
      cursor: 'pointer'
    },
    topBar: {
      '&:hover': {
        backgroundColor: theme.palette.secondary.main
      },
      justifyContent: 'inherit',
      textTransform: 'none'
    }
  };
};

var enhance = (0, _redux.compose)((0, _reactRedux.connect)(mapStateToProps, mapDispatchToProps), (0, _core.withStyles)(styles), (0, _reactI18next.withTranslation)(), (0, _withPlugins.withPlugins)('WindowAuthenticationControl'));

var _default = enhance(_WindowAuthenticationControl.WindowAuthenticationControl);

exports["default"] = _default;