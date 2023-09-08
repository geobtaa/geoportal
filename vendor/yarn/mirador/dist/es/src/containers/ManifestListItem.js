function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

import { compose } from 'redux';
import { connect } from 'react-redux';
import { withTranslation } from 'react-i18next';
import { withStyles } from '@material-ui/core';
import { withPlugins } from '../extend/withPlugins';
import { getManifest, getManifestTitle, getManifestThumbnail, getManifestCanvases, getManifestLogo, getManifestProvider, getWindowManifests } from '../state/selectors';
import * as actions from '../state/actions';
import { ManifestListItem } from '../components/ManifestListItem';
/** */

var mapStateToProps = function mapStateToProps(state, _ref) {
  var manifestId = _ref.manifestId;
  return {
    active: getWindowManifests(state).includes(manifestId),
    error: getManifest(state, {
      manifestId: manifestId
    }).error,
    isFetching: getManifest(state, {
      manifestId: manifestId
    }).isFetching,
    manifestLogo: getManifestLogo(state, {
      manifestId: manifestId
    }),
    provider: getManifest(state, {
      manifestId: manifestId
    }).provider || getManifestProvider(state, {
      manifestId: manifestId
    }),
    ready: !!getManifest(state, {
      manifestId: manifestId
    }).json,
    size: getManifestCanvases(state, {
      manifestId: manifestId
    }).length,
    thumbnail: getManifestThumbnail(state, {
      manifestId: manifestId
    }),
    title: getManifestTitle(state, {
      manifestId: manifestId
    })
  };
};
/**
 * mapDispatchToProps - used to hook up connect to action creators
 * @memberof ManifestListItem
 * @private
 */


var mapDispatchToProps = {
  addWindow: actions.addWindow,
  fetchManifest: actions.fetchManifest
};
/**
 *
 * @param theme
 * @returns {{root: {}, label: {textAlign: string, textTransform: string}}}
 */

var styles = function styles(theme) {
  return {
    active: {},
    buttonGrid: {
      '&:hover': {
        backgroundColor: theme.palette.action.hover
      }
    },
    label: {
      textAlign: 'left',
      textTransform: 'initial'
    },
    logo: {
      height: '2.5rem',
      paddingRight: 8
    },
    placeholder: {
      backgroundColor: theme.palette.grey[300]
    },
    root: _objectSpread({}, theme.mixins.gutters(), {
      '&$active': {
        borderLeft: "4px solid ".concat(theme.palette.primary.main)
      },
      borderLeft: '4px solid transparent'
    })
  };
};

var enhance = compose(withTranslation(), withStyles(styles), connect(mapStateToProps, mapDispatchToProps), withPlugins('ManifestListItem'));
export default enhance(ManifestListItem);