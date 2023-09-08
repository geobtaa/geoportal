function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

import React, { Component } from 'react';
import PropTypes from 'prop-types';
import List from '@material-ui/core/List';
import Typography from '@material-ui/core/Typography';
import RenderingDownloadLink from './RenderingDownloadLink';

/**
 * ManifestDownloadLinks ~
*/

var ManifestDownloadLinks = function (_Component) {
  _inherits(ManifestDownloadLinks, _Component);

  function ManifestDownloadLinks() {
    _classCallCheck(this, ManifestDownloadLinks);

    return _possibleConstructorReturn(this, _Component.apply(this, arguments));
  }

  /**
   * Returns the rendered component
  */
  ManifestDownloadLinks.prototype.render = function render() {
    var _props = this.props,
        classes = _props.classes,
        renderings = _props.renderings;


    return React.createElement(
      React.Fragment,
      null,
      React.createElement(
        Typography,
        { variant: 'h3', className: classes.h3 },
        'Other download options'
      ),
      React.createElement(
        List,
        null,
        renderings.map(function (rendering) {
          return React.createElement(RenderingDownloadLink, { rendering: rendering, key: rendering.id });
        })
      )
    );
  };

  return ManifestDownloadLinks;
}(Component);

export { ManifestDownloadLinks as default };


ManifestDownloadLinks.propTypes = process.env.NODE_ENV !== "production" ? {
  classes: PropTypes.shape({
    h3: PropTypes.string
  }).isRequired,
  renderings: PropTypes.array.isRequired // eslint-disable-line react/forbid-prop-types
} : {};