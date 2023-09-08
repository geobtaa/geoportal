import { compose } from 'redux';
import { connect } from 'react-redux';
import { withTranslation } from 'react-i18next';
import { withPlugins } from '../extend/withPlugins';
import { getManifestDescription, getManifestTitle, getManifestMetadata } from '../state/selectors';
import { ManifestInfo } from '../components/ManifestInfo';
/**
 * mapStateToProps - to hook up connect
 * @memberof WindowSideBarInfoPanel
 * @private
 */

var mapStateToProps = function mapStateToProps(state, _ref) {
  var id = _ref.id,
      windowId = _ref.windowId;
  return {
    manifestDescription: getManifestDescription(state, {
      companionWindowId: id,
      windowId: windowId
    }),
    manifestLabel: getManifestTitle(state, {
      companionWindowId: id,
      windowId: windowId
    }),
    manifestMetadata: getManifestMetadata(state, {
      companionWindowId: id,
      windowId: windowId
    })
  };
};

var enhance = compose(withTranslation(), connect(mapStateToProps), withPlugins('ManifestInfo'));
export default enhance(ManifestInfo);