import { compose } from 'redux';
import { connect } from 'react-redux';
import { withTranslation } from 'react-i18next';
import { withStyles } from '@material-ui/core/styles';
import { withPlugins } from '../extend/withPlugins';
import * as actions from '../state/actions';
import { getManifestLocale, getMetadataLocales, getVisibleCanvases } from '../state/selectors';
import { WindowSideBarInfoPanel } from '../components/WindowSideBarInfoPanel';
/**
 * mapStateToProps - to hook up connect
 * @memberof WindowSideBarInfoPanel
 * @private
 */

var mapStateToProps = function mapStateToProps(state, _ref) {
  var id = _ref.id,
      windowId = _ref.windowId;
  return {
    availableLocales: getMetadataLocales(state, {
      companionWindowId: id,
      windowId: windowId
    }),
    locale: state.companionWindows[id].locale || getManifestLocale(state, {
      windowId: windowId
    }),
    selectedCanvases: getVisibleCanvases(state, {
      windowId: windowId
    }),
    showLocalePicker: state.config.window.showLocalePicker
  };
};
/** */


var mapDispatchToProps = function mapDispatchToProps(dispatch, _ref2) {
  var windowId = _ref2.windowId,
      id = _ref2.id;
  return {
    setLocale: function setLocale(locale) {
      return dispatch(actions.updateCompanionWindow(windowId, id, {
        locale: locale
      }));
    }
  };
};
/**
 *
 * @param theme
 * @returns {label: {paddingLeft: number}}}
 */


var styles = function styles(theme) {
  return {
    section: {
      borderBottom: ".5px solid ".concat(theme.palette.section_divider),
      paddingBottom: theme.spacing(1),
      paddingLeft: theme.spacing(2),
      paddingRight: theme.spacing(1),
      paddingTop: theme.spacing(2)
    }
  };
};

var enhance = compose(withTranslation(), withStyles(styles), connect(mapStateToProps, mapDispatchToProps), withPlugins('WindowSideBarInfoPanel'));
export default enhance(WindowSideBarInfoPanel);