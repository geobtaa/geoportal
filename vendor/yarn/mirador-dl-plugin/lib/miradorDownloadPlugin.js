'use strict';

exports.__esModule = true;

var _extends = Object.assign || function (target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i]; for (var key in source) { if (Object.prototype.hasOwnProperty.call(source, key)) { target[key] = source[key]; } } } return target; };

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _propTypes = require('prop-types');

var _propTypes2 = _interopRequireDefault(_propTypes);

var _ListItemIcon = require('@material-ui/core/ListItemIcon');

var _ListItemIcon2 = _interopRequireDefault(_ListItemIcon);

var _ListItemText = require('@material-ui/core/ListItemText');

var _ListItemText2 = _interopRequireDefault(_ListItemText);

var _MenuItem = require('@material-ui/core/MenuItem');

var _MenuItem2 = _interopRequireDefault(_MenuItem);

var _VerticalAlignBottomSharp = require('@material-ui/icons/VerticalAlignBottomSharp');

var _VerticalAlignBottomSharp2 = _interopRequireDefault(_VerticalAlignBottomSharp);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var downloadDialogReducer = function downloadDialogReducer() {
  var state = arguments.length > 0 && arguments[0] !== undefined ? arguments[0] : {};
  var action = arguments[1];

  if (action.type === 'OPEN_WINDOW_DIALOG') {
    var _extends2;

    return _extends({}, state, (_extends2 = {}, _extends2[action.windowId] = {
      openDialog: action.dialogType
    }, _extends2));
  }

  if (action.type === 'CLOSE_WINDOW_DIALOG') {
    var _extends3;

    return _extends({}, state, (_extends3 = {}, _extends3[action.windowId] = {
      openDialog: null
    }, _extends3));
  }
  return state;
};

var mapDispatchToProps = function mapDispatchToProps(dispatch, _ref) {
  var windowId = _ref.windowId;
  return {
    openDownloadDialog: function openDownloadDialog() {
      return dispatch({ type: 'OPEN_WINDOW_DIALOG', windowId: windowId, dialogType: 'download' });
    }
  };
};

var MiradorDownload = function (_Component) {
  _inherits(MiradorDownload, _Component);

  function MiradorDownload() {
    _classCallCheck(this, MiradorDownload);

    return _possibleConstructorReturn(this, _Component.apply(this, arguments));
  }

  MiradorDownload.prototype.openDialogAndCloseMenu = function openDialogAndCloseMenu() {
    var _props = this.props,
        handleClose = _props.handleClose,
        openDownloadDialog = _props.openDownloadDialog;


    openDownloadDialog();
    handleClose();
  };

  MiradorDownload.prototype.render = function render() {
    var _this2 = this;

    return _react2.default.createElement(
      _react2.default.Fragment,
      null,
      _react2.default.createElement(
        _MenuItem2.default,
        { onClick: function onClick() {
            return _this2.openDialogAndCloseMenu();
          } },
        _react2.default.createElement(
          _ListItemIcon2.default,
          null,
          _react2.default.createElement(_VerticalAlignBottomSharp2.default, null)
        ),
        _react2.default.createElement(
          _ListItemText2.default,
          { primaryTypographyProps: { variant: 'body1' } },
          'Download'
        )
      )
    );
  };

  return MiradorDownload;
}(_react.Component);

MiradorDownload.propTypes = process.env.NODE_ENV !== "production" ? {
  handleClose: _propTypes2.default.func,
  openDownloadDialog: _propTypes2.default.func
} : {};

MiradorDownload.defaultProps = {
  handleClose: function handleClose() {},
  openDownloadDialog: function openDownloadDialog() {}
};

exports.default = {
  target: 'WindowTopBarPluginMenu',
  mode: 'add',
  name: 'MiradorDownloadPlugin',
  component: MiradorDownload,
  mapDispatchToProps: mapDispatchToProps,
  reducers: {
    windowDialogs: downloadDialogReducer
  }
};
module.exports = exports['default'];