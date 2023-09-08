function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _possibleConstructorReturn(self, call) { if (!self) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return call && (typeof call === "object" || typeof call === "function") ? call : self; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function, not " + typeof superClass); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, enumerable: false, writable: true, configurable: true } }); if (superClass) Object.setPrototypeOf ? Object.setPrototypeOf(subClass, superClass) : subClass.__proto__ = superClass; }

import React, { Component } from 'react';
import PropTypes from 'prop-types';
import Typography from '@material-ui/core/Typography';
import Link from '@material-ui/core/Link';
import List from '@material-ui/core/List';
import ListItem from '@material-ui/core/ListItem';
import uniqBy from 'lodash/uniqBy';
import { OSDReferences } from 'mirador/dist/es/src/plugins/OSDReferences';
import RenderingDownloadLink from './RenderingDownloadLink';

/**
 * CanvasDownloadLinks ~
*/

var CanvasDownloadLinks = function (_Component) {
  _inherits(CanvasDownloadLinks, _Component);

  function CanvasDownloadLinks() {
    _classCallCheck(this, CanvasDownloadLinks);

    return _possibleConstructorReturn(this, _Component.apply(this, arguments));
  }

  CanvasDownloadLinks.prototype.zoomedImageLabel = function zoomedImageLabel() {
    var bounds = this.currentBounds();
    return 'Zoomed region (' + Math.floor(bounds.width) + ' x ' + Math.floor(bounds.height) + 'px)';
  };

  CanvasDownloadLinks.prototype.fullImageLabel = function fullImageLabel() {
    var canvas = this.props.canvas;


    return 'Whole image (' + canvas.getWidth() + ' x ' + canvas.getHeight() + 'px)';
  };

  CanvasDownloadLinks.prototype.smallImageLabel = function smallImageLabel() {
    var canvas = this.props.canvas;


    return 'Whole image (1000 x ' + Math.floor(1000 * canvas.getHeight() / canvas.getWidth()) + 'px)';
  };

  CanvasDownloadLinks.prototype.zoomedImageUrl = function zoomedImageUrl() {
    var canvas = this.props.canvas;

    var bounds = this.currentBounds();
    var boundsUrl = canvas.getCanonicalImageUri().replace(/\/full\/.*\/0\//, '/' + bounds.x + ',' + bounds.y + ',' + bounds.width + ',' + bounds.height + '/full/0/');

    return boundsUrl + '?download=true';
  };

  CanvasDownloadLinks.prototype.imageUrlForSize = function imageUrlForSize(size) {
    var canvas = this.props.canvas;


    return canvas.getCanonicalImageUri(size.width) + '?download=true';
  };

  CanvasDownloadLinks.prototype.fullImageUrl = function fullImageUrl() {
    var canvas = this.props.canvas;


    return canvas.getCanonicalImageUri().replace(/\/full\/.*\/0\//, '/full/full/0/') + '?download=true';
  };

  CanvasDownloadLinks.prototype.thousandPixelWideImage = function thousandPixelWideImage() {
    var canvas = this.props.canvas;


    return canvas.getCanonicalImageUri('1000') + '?download=true';
  };

  CanvasDownloadLinks.prototype.osdViewport = function osdViewport() {
    var windowId = this.props.windowId;

    return OSDReferences.get(windowId).current.viewer.viewport;
  };

  CanvasDownloadLinks.prototype.currentBounds = function currentBounds() {
    var bounds = this.osdViewport().getBounds();

    return Object.keys(bounds).reduce(function (object, key) {
      object[key] = Math.ceil(bounds[key]); // eslint-disable-line no-param-reassign
      return object;
    }, {});
  };

  CanvasDownloadLinks.prototype.definedSizesRestrictsDownload = function definedSizesRestrictsDownload() {
    var infoResponse = this.props.infoResponse;

    if (!infoResponse.json) return false;
    var _infoResponse$json = infoResponse.json,
        height = _infoResponse$json.height,
        width = _infoResponse$json.width;


    if (this.definedSizes().length !== 1) return false;

    return this.definedSizes()[0].width <= width && this.definedSizes()[0].height <= height;
  };

  CanvasDownloadLinks.prototype.displayCurrentZoomLink = function displayCurrentZoomLink() {
    var _props = this.props,
        restrictDownloadOnSizeDefinition = _props.restrictDownloadOnSizeDefinition,
        infoResponse = _props.infoResponse,
        viewType = _props.viewType;


    if (viewType !== 'single') return false;
    if (restrictDownloadOnSizeDefinition && this.definedSizesRestrictsDownload()) return false;
    if (!(infoResponse && infoResponse.json)) return false;

    var bounds = this.currentBounds();
    return bounds.height < infoResponse.json.height && bounds.width < infoResponse.json.width && bounds.x >= 0 && bounds.y >= 0;
  };

  /**
   * This only returns unique sizes
  */


  CanvasDownloadLinks.prototype.definedSizes = function definedSizes() {
    var infoResponse = this.props.infoResponse;

    if (!(infoResponse && infoResponse.json && infoResponse.json.sizes)) return [];

    return uniqBy(infoResponse.json.sizes, function (size) {
      return '' + size.width + size.height;
    });
  };

  CanvasDownloadLinks.prototype.fullImageLink = function fullImageLink() {
    return React.createElement(
      ListItem,
      { disableGutters: true, divider: true, key: this.fullImageUrl() },
      React.createElement(
        Link,
        { href: this.fullImageUrl(), rel: 'noopener noreferrer', target: '_blank', variant: 'body1' },
        this.fullImageLabel()
      )
    );
  };

  CanvasDownloadLinks.prototype.thousandPixelWideLink = function thousandPixelWideLink() {
    var canvas = this.props.canvas;


    if (canvas.getWidth() < 1000) return '';

    return React.createElement(
      ListItem,
      { disableGutters: true, divider: true, key: this.thousandPixelWideImage() },
      React.createElement(
        Link,
        { href: this.thousandPixelWideImage(), rel: 'noopener noreferrer', target: '_blank', variant: 'body1' },
        this.smallImageLabel()
      )
    );
  };

  CanvasDownloadLinks.prototype.linksForDefinedSizes = function linksForDefinedSizes() {
    var _this2 = this;

    return this.definedSizes().map(function (size) {
      return React.createElement(
        ListItem,
        { disableGutters: true, divider: true, key: '' + size.width + size.height },
        React.createElement(
          Link,
          { href: _this2.imageUrlForSize(size), rel: 'noopener noreferrer', target: '_blank', variant: 'body1' },
          'Whole image (' + size.width + ' x ' + size.height + 'px)'
        )
      );
    });
  };

  /**
   * Returns the rendered component
  */


  CanvasDownloadLinks.prototype.render = function render() {
    var _props2 = this.props,
        canvas = _props2.canvas,
        canvasLabel = _props2.canvasLabel,
        classes = _props2.classes;


    return React.createElement(
      React.Fragment,
      null,
      React.createElement(
        Typography,
        { noWrap: true, variant: 'h3', className: classes.h3 },
        canvasLabel
      ),
      React.createElement(
        List,
        null,
        this.displayCurrentZoomLink() && React.createElement(
          ListItem,
          { disableGutters: true, divider: true },
          React.createElement(
            Link,
            { href: this.zoomedImageUrl(), rel: 'noopener noreferrer', target: '_blank', variant: 'body1' },
            this.zoomedImageLabel()
          )
        ),
        this.definedSizes().length === 0 && [this.fullImageLink(), this.thousandPixelWideLink()],
        this.definedSizes().length > 0 && this.linksForDefinedSizes(),
        canvas.getRenderings().map(function (rendering) {
          return React.createElement(RenderingDownloadLink, { rendering: rendering, key: rendering.id });
        })
      )
    );
  };

  return CanvasDownloadLinks;
}(Component);

export { CanvasDownloadLinks as default };


CanvasDownloadLinks.propTypes = process.env.NODE_ENV !== "production" ? {
  canvas: PropTypes.shape({
    id: PropTypes.string.isRequired,
    getCanonicalImageUri: PropTypes.func.isRequired,
    getHeight: PropTypes.func.isRequired,
    getRenderings: PropTypes.func.isRequired,
    getWidth: PropTypes.func.isRequired
  }).isRequired,
  canvasLabel: PropTypes.string.isRequired, // canvasLabel is passed because we need access to redux
  classes: PropTypes.shape({
    h3: PropTypes.string
  }).isRequired,
  infoResponse: PropTypes.shape({
    json: PropTypes.shape({
      height: PropTypes.number,
      sizes: PropTypes.arrayOf(PropTypes.shape({ height: PropTypes.number, width: PropTypes.number })),
      width: PropTypes.number
    })
  }).isRequired,
  restrictDownloadOnSizeDefinition: PropTypes.bool.isRequired,
  viewType: PropTypes.string.isRequired,
  windowId: PropTypes.string.isRequired
} : {};