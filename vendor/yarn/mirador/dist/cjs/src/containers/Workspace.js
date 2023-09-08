"use strict";

Object.defineProperty(exports, "__esModule", {
  value: true
});
exports["default"] = void 0;

var _redux = require("redux");

var _reactRedux = require("react-redux");

var _reactI18next = require("react-i18next");

var _styles = require("@material-ui/core/styles");

var _withPlugins = require("../extend/withPlugins");

var _Workspace = require("../components/Workspace");

var _selectors = require("../state/selectors");

/**
 * mapStateToProps - to hook up connect
 * @memberof Workspace
 * @private
 */
var mapStateToProps = function mapStateToProps(state) {
  return {
    isWorkspaceControlPanelVisible: state.config.workspaceControlPanel.enabled,
    maximizedWindowIds: (0, _selectors.getMaximizedWindowsIds)(state),
    windowIds: (0, _selectors.getWindowIds)(state),
    workspaceId: state.workspace.id,
    workspaceType: (0, _selectors.getWorkspaceType)(state)
  };
};
/**
 * @param theme
 */


var styles = function styles(theme) {
  return {
    workspaceViewport: {
      bottom: 0,
      left: 0,
      margin: 0,
      overflow: 'hidden',
      position: 'absolute',
      right: 0,
      top: 0
    },
    workspaceWithControlPanel: {
      paddingTop: 74
    },
    // injection order matters here
    // eslint-disable-next-line sort-keys
    '@media (min-width: 600px)': {
      workspaceWithControlPanel: {
        paddingLeft: 68,
        paddingTop: 0
      }
    }
  };
};

var enhance = (0, _redux.compose)((0, _reactI18next.withTranslation)(), (0, _styles.withStyles)(styles), (0, _reactRedux.connect)(mapStateToProps), (0, _withPlugins.withPlugins)('Workspace') // further HOC go here
);

var _default = enhance(_Workspace.Workspace);

exports["default"] = _default;