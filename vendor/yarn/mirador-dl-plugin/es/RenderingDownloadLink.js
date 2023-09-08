function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Link from '@material-ui/core/Link';
import ListItem from '@material-ui/core/ListItem';
import ListItemText from '@material-ui/core/ListItemText';

/**
 * RenderingDownloadLink ~
*/

var RenderingDownloadLink = function (_Component) {
  _inherits(RenderingDownloadLink, _Component);

  function RenderingDownloadLink() {
    _classCallCheck(this, RenderingDownloadLink);

    return _possibleConstructorReturn(this, _Component.apply(this, arguments));
  }

  RenderingDownloadLink.prototype.render = function render() {
    var rendering = this.props.rendering;

    return React.createElement(
      ListItem,
      { disableGutters: true, divider: true, key: rendering.id },
      React.createElement(
        ListItemText,
        { primaryTypographyProps: { variant: 'body1' } },
        React.createElement(
          Link,
          { href: rendering.id, rel: 'noopener noreferrer', target: '_blank', variant: 'body1' },
          rendering.getLabel().map(function (label) {
            return label.value;
          })[0]
        ),
        rendering.getFormat() && rendering.getFormat().value && ' (' + rendering.getFormat().value + ')'
      )
    );
  };

  return RenderingDownloadLink;
}(Component);

export { RenderingDownloadLink as default };


RenderingDownloadLink.propTypes = process.env.NODE_ENV !== "production" ? {
  rendering: PropTypes.shape({
    id: PropTypes.string.isRequired,
    getLabel: PropTypes.func.isRequired,
    getFormat: PropTypes.func.isRequired
  }).isRequired
} : {};