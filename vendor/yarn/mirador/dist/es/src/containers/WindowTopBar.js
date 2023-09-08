import { compose } from 'redux';
import { connect } from 'react-redux';
import { withTranslation } from 'react-i18next';
import { withStyles } from '@material-ui/core';
import { withPlugins } from '../extend/withPlugins';
import * as actions from '../state/actions';
import { getManifestTitle, getWindow } from '../state/selectors';
import { WindowTopBar } from '../components/WindowTopBar';
/** mapStateToProps */

var mapStateToProps = function mapStateToProps(state, _ref) {
  var windowId = _ref.windowId;
  return {
    allowClose: state.config.window.allowClose,
    allowFullscreen: state.config.window.allowFullscreen,
    allowMaximize: state.config.window.allowMaximize,
    allowTopMenuButton: state.config.window.allowTopMenuButton,
    allowWindowSideBar: state.config.window.allowWindowSideBar,
    focused: state.workspace.focusedWindowId === windowId,
    manifestTitle: getManifestTitle(state, {
      windowId: windowId
    }),
    maximized: (getWindow(state, {
      windowId: windowId
    }) || {}).maximized
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof ManifestListItem
 * @private
 */


var mapDispatchToProps = function mapDispatchToProps(dispatch, _ref2) {
  var windowId = _ref2.windowId;
  return {
    focusWindow: function focusWindow() {
      return dispatch(actions.focusWindow(windowId));
    },
    maximizeWindow: function maximizeWindow() {
      return dispatch(actions.maximizeWindow(windowId));
    },
    minimizeWindow: function minimizeWindow() {
      return dispatch(actions.minimizeWindow(windowId));
    },
    removeWindow: function removeWindow() {
      return dispatch(actions.removeWindow(windowId));
    },
    toggleWindowSideBar: function toggleWindowSideBar() {
      return dispatch(actions.toggleWindowSideBar(windowId));
    }
  };
};
/**
 * @param theme
 * @returns {{typographyBody: {flexGrow: number, fontSize: number|string},
 * windowTopBarStyle: {minHeight: number, paddingLeft: number, backgroundColor: string}}}
 */


var styles = function styles(theme) {
  return {
    focused: {},
    windowTopBarStyle: {
      '&$focused': {
        borderTop: "2px solid ".concat(theme.palette.primary.main)
      },
      backgroundColor: theme.palette.shades.main,
      borderTop: '2px solid transparent',
      minHeight: 32,
      paddingLeft: theme.spacing(0.5),
      paddingRight: theme.spacing(0.5)
    },
    windowTopBarStyleDraggable: {
      cursor: 'move'
    }
  };
};

var enhance = compose(withTranslation(), withStyles(styles), connect(mapStateToProps, mapDispatchToProps), withPlugins('WindowTopBar'));
export default enhance(WindowTopBar);