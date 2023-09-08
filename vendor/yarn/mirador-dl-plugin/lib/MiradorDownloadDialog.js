'use strict';

exports.__esModule = true;
exports.MiradorDownloadDialog = undefined;

var _react = require('react');

var _react2 = _interopRequireDefault(_react);

var _propTypes = require('prop-types');

var _propTypes2 = _interopRequireDefault(_propTypes);

var _styles = require('@material-ui/core/styles');

var _Button = require('@material-ui/core/Button');

var _Button2 = _interopRequireDefault(_Button);

var _Dialog = require('@material-ui/core/Dialog');

var _Dialog2 = _interopRequireDefault(_Dialog);

var _DialogActions = require('@material-ui/core/DialogActions');

var _DialogActions2 = _interopRequireDefault(_DialogActions);

var _DialogTitle = require('@material-ui/core/DialogTitle');

var _DialogTitle2 = _interopRequireDefault(_DialogTitle);

var _Typography = require('@material-ui/core/Typography');

var _Typography2 = _interopRequireDefault(_Typography);

var _canvases = require('mirador/dist/es/src/state/selectors/canvases');

var _windows = require('mirador/dist/es/src/state/selectors/windows');

var _manifests = require('mirador/dist/es/src/state/selectors/manifests');

var _config = require('mirador/dist/es/src/state/selectors/config');

var _ScrollIndicatedDialogContent = require('mirador/dist/es/src/containers/ScrollIndicatedDialogContent');

var _ScrollIndicatedDialogContent2 = _interopRequireDefault(_ScrollIndicatedDialogContent);

var _CanvasDownloadLinks = require('./CanvasDownloadLinks');

var _CanvasDownloadLinks2 = _interopRequireDefault(_CanvasDownloadLinks);

var _ManifestDownloadLinks = require('./ManifestDownloadLinks');

var _ManifestDownloadLinks2 = _interopRequireDefault(_ManifestDownloadLinks);

function _interopRequireDefault(obj) { return obj && obj.__esModule ? obj : { default: obj }; }

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

var mapDispatchToProps = function mapDispatchToProps(dispatch, _ref) {
  var windowId = _ref.windowId;
  return {
    closeDialog: function closeDialog() {
      return dispatch({ type: 'CLOSE_WINDOW_DIALOG', windowId: windowId });
    }
  };
};

var mapStateToProps = function mapStateToProps(state, _ref2) {
  var windowId = _ref2.windowId;
  return {
    canvases: (0, _canvases.getVisibleCanvases)(state, { windowId: windowId }),
    canvasLabel: function canvasLabel(canvasIndex) {
      return (0, _canvases.getCanvasLabel)(state, { canvasIndex: canvasIndex, windowId: windowId });
    },
    containerId: (0, _config.getContainerId)(state),
    infoResponse: function infoResponse(canvasIndex) {
      return (0, _canvases.selectInfoResponse)(state, { windowId: windowId, canvasIndex: canvasIndex }) || {};
    },
    manifest: (0, _manifests.getManifestoInstance)(state, { windowId: windowId }),
    restrictDownloadOnSizeDefinition: state.config.miradorDownloadPlugin && state.config.miradorDownloadPlugin.restrictDownloadOnSizeDefinition,
    open: state.windowDialogs[windowId] && state.windowDialogs[windowId].openDialog === 'download',
    viewType: (0, _windows.getWindowViewType)(state, { windowId: windowId })
  };
};

/**
 * MiradorDownloadDialog ~
*/

var MiradorDownloadDialog = exports.MiradorDownloadDialog = function (_Component) {
  _inherits(MiradorDownloadDialog, _Component);

  function MiradorDownloadDialog() {
    _classCallCheck(this, MiradorDownloadDialog);

    return _possibleConstructorReturn(this, _Component.apply(this, arguments));
  }

  MiradorDownloadDialog.prototype.renderings = function renderings() {
    var manifest = this.props.manifest;

    if (!(manifest && manifest.getSequences() && manifest.getSequences()[0] && manifest.getSequences()[0].getRenderings())) return [];

    return manifest.getSequences()[0].getRenderings();
  };

  /**
   * Returns the rendered component
  */


  MiradorDownloadDialog.prototype.render = function render() {
    var _props = this.props,
        canvases = _props.canvases,
        canvasLabel = _props.canvasLabel,
        classes = _props.classes,
        closeDialog = _props.closeDialog,
        containerId = _props.containerId,
        infoResponse = _props.infoResponse,
        open = _props.open,
        restrictDownloadOnSizeDefinition = _props.restrictDownloadOnSizeDefinition,
        viewType = _props.viewType,
        windowId = _props.windowId;


    if (!open) return '';

    return _react2.default.createElement(
      _react2.default.Fragment,
      null,
      _react2.default.createElement(
        _Dialog2.default,
        {
          container: document.querySelector('#' + containerId + ' .mirador-viewer'),
          disableEnforceFocus: true,
          onClose: closeDialog,
          open: open,
          scroll: 'paper',
          fullWidth: true,
          maxWidth: 'xs'
        },
        _react2.default.createElement(
          _DialogTitle2.default,
          { disableTypography: true, className: classes.h2 },
          _react2.default.createElement(
            _Typography2.default,
            { variant: 'h2' },
            'Download'
          )
        ),
        _react2.default.createElement(
          _ScrollIndicatedDialogContent2.default,
          null,
          canvases.map(function (canvas) {
            return _react2.default.createElement(_CanvasDownloadLinks2.default, {
              canvas: canvas,
              canvasLabel: canvasLabel(canvas.index),
              classes: classes,
              infoResponse: infoResponse(canvas.index),
              restrictDownloadOnSizeDefinition: restrictDownloadOnSizeDefinition,
              key: canvas.id,
              viewType: viewType,
              windowId: windowId
            });
          }),
          this.renderings().length > 0 && _react2.default.createElement(_ManifestDownloadLinks2.default, { classes: classes, renderings: this.renderings() })
        ),
        _react2.default.createElement(
          _DialogActions2.default,
          null,
          _react2.default.createElement(
            _Button2.default,
            { onClick: closeDialog, color: 'primary' },
            'Close'
          )
        )
      )
    );
  };

  return MiradorDownloadDialog;
}(_react.Component);

MiradorDownloadDialog.propTypes = process.env.NODE_ENV !== "production" ? {
  canvasLabel: _propTypes2.default.func.isRequired,
  canvases: _propTypes2.default.arrayOf(_propTypes2.default.shape({ id: _propTypes2.default.string, index: _propTypes2.default.number })),
  classes: _propTypes2.default.shape({
    h2: _propTypes2.default.string,
    h3: _propTypes2.default.string
  }).isRequired,
  closeDialog: _propTypes2.default.func.isRequired,
  containerId: _propTypes2.default.string.isRequired,
  infoResponse: _propTypes2.default.func.isRequired,
  manifest: _propTypes2.default.shape({
    getSequences: _propTypes2.default.func
  }),
  open: _propTypes2.default.bool,
  restrictDownloadOnSizeDefinition: _propTypes2.default.bool,
  viewType: _propTypes2.default.string.isRequired,
  windowId: _propTypes2.default.string.isRequired
} : {};
MiradorDownloadDialog.defaultProps = {
  canvases: [],
  manifest: {},
  open: false,
  restrictDownloadOnSizeDefinition: false
};

var styles = function styles() {
  return {
    h2: {
      paddingBottom: 0
    },
    h3: {
      marginTop: '20px'
    }
  };
};

exports.default = {
  target: 'Window',
  mode: 'add',
  name: 'MiradorDownloadDialog',
  component: (0, _styles.withStyles)(styles)(MiradorDownloadDialog),
  mapDispatchToProps: mapDispatchToProps,
  mapStateToProps: mapStateToProps
};