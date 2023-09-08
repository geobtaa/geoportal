function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

import React, { Component } from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import Button from '@material-ui/core/Button';
import Dialog from '@material-ui/core/Dialog';
import DialogActions from '@material-ui/core/DialogActions';
import DialogTitle from '@material-ui/core/DialogTitle';
import Typography from '@material-ui/core/Typography';
import { getCanvasLabel, getVisibleCanvases, selectInfoResponse } from 'mirador/dist/es/src/state/selectors/canvases';
import { getWindowViewType } from 'mirador/dist/es/src/state/selectors/windows';
import { getManifestoInstance } from 'mirador/dist/es/src/state/selectors/manifests';
import { getContainerId } from 'mirador/dist/es/src/state/selectors/config';
import ScrollIndicatedDialogContent from 'mirador/dist/es/src/containers/ScrollIndicatedDialogContent';
import CanvasDownloadLinks from './CanvasDownloadLinks';
import ManifestDownloadLinks from './ManifestDownloadLinks';

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
    canvases: getVisibleCanvases(state, { windowId: windowId }),
    canvasLabel: function canvasLabel(canvasIndex) {
      return getCanvasLabel(state, { canvasIndex: canvasIndex, windowId: windowId });
    },
    containerId: getContainerId(state),
    infoResponse: function infoResponse(canvasIndex) {
      return selectInfoResponse(state, { windowId: windowId, canvasIndex: canvasIndex }) || {};
    },
    manifest: getManifestoInstance(state, { windowId: windowId }),
    restrictDownloadOnSizeDefinition: state.config.miradorDownloadPlugin && state.config.miradorDownloadPlugin.restrictDownloadOnSizeDefinition,
    open: state.windowDialogs[windowId] && state.windowDialogs[windowId].openDialog === 'download',
    viewType: getWindowViewType(state, { windowId: windowId })
  };
};

/**
 * MiradorDownloadDialog ~
*/
export var MiradorDownloadDialog = function (_Component) {
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

    return React.createElement(
      React.Fragment,
      null,
      React.createElement(
        Dialog,
        {
          container: document.querySelector('#' + containerId + ' .mirador-viewer'),
          disableEnforceFocus: true,
          onClose: closeDialog,
          open: open,
          scroll: 'paper',
          fullWidth: true,
          maxWidth: 'xs'
        },
        React.createElement(
          DialogTitle,
          { disableTypography: true, className: classes.h2 },
          React.createElement(
            Typography,
            { variant: 'h2' },
            'Download'
          )
        ),
        React.createElement(
          ScrollIndicatedDialogContent,
          null,
          canvases.map(function (canvas) {
            return React.createElement(CanvasDownloadLinks, {
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
          this.renderings().length > 0 && React.createElement(ManifestDownloadLinks, { classes: classes, renderings: this.renderings() })
        ),
        React.createElement(
          DialogActions,
          null,
          React.createElement(
            Button,
            { onClick: closeDialog, color: 'primary' },
            'Close'
          )
        )
      )
    );
  };

  return MiradorDownloadDialog;
}(Component);

MiradorDownloadDialog.propTypes = process.env.NODE_ENV !== "production" ? {
  canvasLabel: PropTypes.func.isRequired,
  canvases: PropTypes.arrayOf(PropTypes.shape({ id: PropTypes.string, index: PropTypes.number })),
  classes: PropTypes.shape({
    h2: PropTypes.string,
    h3: PropTypes.string
  }).isRequired,
  closeDialog: PropTypes.func.isRequired,
  containerId: PropTypes.string.isRequired,
  infoResponse: PropTypes.func.isRequired,
  manifest: PropTypes.shape({
    getSequences: PropTypes.func
  }),
  open: PropTypes.bool,
  restrictDownloadOnSizeDefinition: PropTypes.bool,
  viewType: PropTypes.string.isRequired,
  windowId: PropTypes.string.isRequired
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

export default {
  target: 'Window',
  mode: 'add',
  name: 'MiradorDownloadDialog',
  component: withStyles(styles)(MiradorDownloadDialog),
  mapDispatchToProps: mapDispatchToProps,
  mapStateToProps: mapStateToProps
};