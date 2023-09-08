import { compose } from 'redux';
import { connect } from 'react-redux';
import { withTranslation } from 'react-i18next';
import { withStyles } from '@material-ui/core/styles';
import { withPlugins } from '../extend/withPlugins';
import { OpenSeadragonViewer } from '../components/OpenSeadragonViewer';
import * as actions from '../state/actions';
import CanvasWorld from '../lib/CanvasWorld';
import { getVisibleCanvasNonTiledResources, getCurrentCanvas, getSelectedAnnotationsOnCanvases, getHighlightedAnnotationsOnCanvases, getCanvasLabel, getManifestViewingDirection, getLayersForVisibleCanvases, getVisibleCanvases, getViewer, getSearchAnnotationsForWindow, getSelectedContentSearchAnnotations, getTheme } from '../state/selectors';
/**
 * mapStateToProps - used to hook up connect to action creators
 * @memberof Window
 * @private
 */

var mapStateToProps = function mapStateToProps(state, _ref) {
  var companionWindowId = _ref.companionWindowId,
      windowId = _ref.windowId;
  return {
    canvasWorld: new CanvasWorld(getVisibleCanvases(state, {
      windowId: windowId
    }), getLayersForVisibleCanvases(state, {
      windowId: windowId
    }), getManifestViewingDirection(state, {
      windowId: windowId
    })),
    highlightedAnnotations: getHighlightedAnnotationsOnCanvases(state, {
      windowId: windowId
    }),
    label: getCanvasLabel(state, {
      canvasId: (getCurrentCanvas(state, {
        windowId: windowId
      }) || {}).id,
      windowId: windowId
    }),
    nonTiledImages: getVisibleCanvasNonTiledResources(state, {
      windowId: windowId
    }),
    osdConfig: state.config.osdConfig,
    palette: getTheme(state).palette,
    searchAnnotations: getSearchAnnotationsForWindow(state, {
      windowId: windowId
    }),
    selectedAnnotations: getSelectedAnnotationsOnCanvases(state, {
      windowId: windowId
    }),
    selectedContentSearchAnnotations: getSelectedContentSearchAnnotations(state, {
      windowId: windowId
    }),
    viewer: getViewer(state, {
      windowId: windowId
    })
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof ManifestListItem
 * @private
 */


var mapDispatchToProps = {
  updateViewport: actions.updateViewport
};
var styles = {
  osdContainer: {
    flex: 1,
    position: 'relative'
  }
};
var enhance = compose(withStyles(styles), withTranslation(), connect(mapStateToProps, mapDispatchToProps), withPlugins('OpenSeadragonViewer'));
export default enhance(OpenSeadragonViewer);