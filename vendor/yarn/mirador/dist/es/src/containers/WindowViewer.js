import { compose } from 'redux';
import { connect } from 'react-redux';
import { withPlugins } from '../extend/withPlugins';
import * as actions from '../state/actions';
import { WindowViewer } from '../components/WindowViewer';
import { getVisibleCanvases, getCurrentCanvas, getWindowViewType } from '../state/selectors';
/**
 * mapStateToProps - to hook up connect
 * @memberof WindowViewer
 * @private
 */

var mapStateToProps = function mapStateToProps(state, _ref) {
  var windowId = _ref.windowId;
  return {
    currentCanvases: getVisibleCanvases(state, {
      windowId: windowId
    }) || [],
    currentCanvasId: (getCurrentCanvas(state, {
      windowId: windowId
    }) || {}).id,
    infoResponses: state.infoResponses,
    view: getWindowViewType(state, {
      windowId: windowId
    })
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof WindowViewer
 * @private
 */


var mapDispatchToProps = {
  fetchAnnotation: actions.fetchAnnotation,
  fetchInfoResponse: actions.fetchInfoResponse,
  receiveAnnotation: actions.receiveAnnotation
};
var enhance = compose(connect(mapStateToProps, mapDispatchToProps), withPlugins('WindowViewer') // further HOC go here
);
export default enhance(WindowViewer);