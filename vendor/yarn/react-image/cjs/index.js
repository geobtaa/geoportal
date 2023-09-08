'use strict';

function _interopDefault (ex) { return (ex && (typeof ex === 'object') && 'default' in ex) ? ex['default'] : ex; }

var _objectWithoutProperties = _interopDefault(require('@babel/runtime/helpers/objectWithoutProperties'));
var _classCallCheck = _interopDefault(require('@babel/runtime/helpers/classCallCheck'));
var _createClass = _interopDefault(require('@babel/runtime/helpers/createClass'));
var _possibleConstructorReturn = _interopDefault(require('@babel/runtime/helpers/possibleConstructorReturn'));
var _getPrototypeOf = _interopDefault(require('@babel/runtime/helpers/getPrototypeOf'));
var _assertThisInitialized = _interopDefault(require('@babel/runtime/helpers/assertThisInitialized'));
var _inherits = _interopDefault(require('@babel/runtime/helpers/inherits'));
var _defineProperty = _interopDefault(require('@babel/runtime/helpers/defineProperty'));
var React = require('react');
var React__default = _interopDefault(React);
var propTypes = require('prop-types');

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }
var cache = {};
var imgPropTypes = {
  loader: propTypes.node,
  unloader: propTypes.node,
  decode: propTypes.bool,
  crossorigin: propTypes.string,
  src: propTypes.oneOfType([propTypes.string, propTypes.array]),
  container: propTypes.func,
  loaderContainer: propTypes.func,
  unloaderContainer: propTypes.func
};

var Img =
/*#__PURE__*/
function (_Component) {
  _inherits(Img, _Component);

  function Img(props) {
    var _this;

    _classCallCheck(this, Img);

    _this = _possibleConstructorReturn(this, _getPrototypeOf(Img).call(this, props)); // default loader/unloader container to just container. If no container was set
    // this will be a noop

    _defineProperty(_assertThisInitialized(_this), "srcToArray", function (src) {
      return (Array.isArray(src) ? src : [src]).filter(function (x) {
        return x;
      });
    });

    _defineProperty(_assertThisInitialized(_this), "onLoad", function () {
      cache[_this.sourceList[_this.state.currentIndex]] = true;
      /* istanbul ignore else */

      if (_this.i) _this.setState({
        isLoaded: true
      });
    });

    _defineProperty(_assertThisInitialized(_this), "onError", function () {
      cache[_this.sourceList[_this.state.currentIndex]] = false; // if the current image has already been destroyed, we are probably no longer mounted
      // no need to do anything then

      /* istanbul ignore else */

      if (!_this.i) return false; // before loading the next image, check to see if it was ever loaded in the past

      for (var nextIndex = _this.state.currentIndex + 1; nextIndex < _this.sourceList.length; nextIndex++) {
        // get next img
        var src = _this.sourceList[nextIndex]; // if we have never seen it, its the one we want to try next

        if (!(src in cache)) {
          _this.setState({
            currentIndex: nextIndex
          });

          break;
        } // if we know it exists, use it!


        if (cache[src] === true) {
          _this.setState({
            currentIndex: nextIndex,
            isLoading: false,
            isLoaded: true
          });

          return true;
        } // if we know it doesn't exist, skip it!

        /* istanbul ignore else */


        if (cache[src] === false) continue;
      } // currentIndex is zero bases, length is 1 based.
      // if we have no more sources to try, return - we are done


      if (nextIndex === _this.sourceList.length) return _this.setState({
        isLoading: false
      }); // otherwise, try the next img

      _this.loadImg();
    });

    _defineProperty(_assertThisInitialized(_this), "loadImg", function () {
      {
        _this.i = new Image();
      }

      _this.i.src = _this.sourceList[_this.state.currentIndex];

      if (_this.props.crossorigin) {
        _this.i.crossOrigin = _this.props.crossorigin;
      }

      if (_this.props.decode && _this.i.decode) {
        _this.i.decode().then(_this.onLoad)["catch"](_this.onError);
      } else {
        _this.i.onload = _this.onLoad;
        _this.i.onerror = _this.onError;
      }
    });

    _defineProperty(_assertThisInitialized(_this), "unloadImg", function () {
      _this.i.onerror = null;
      _this.i.onload = null; // abort any current downloads https://github.com/mbrevda/react-image/pull/223

      _this.i.src = '';

      try {
        delete _this.i.src;
      } catch (e) {// On Safari in Strict mode this will throw an exception,
        //  - https://github.com/mbrevda/react-image/issues/187
        // We don't need to do anything about it.
      }

      delete _this.i;
    });

    _this.loaderContainer = props.loaderContainer || props.container;
    _this.unloaderContainer = props.unloaderContainer || props.container;
    _this.sourceList = _this.srcToArray(_this.props.src); // check cache to decide at which index to start

    for (var i = 0; i < _this.sourceList.length; i++) {
      // if we've never seen this image before, the cache wont help.
      // no need to look further, just start loading

      /* istanbul ignore else */
      if (!(_this.sourceList[i] in cache)) break; // if we have loaded this image before, just load it again

      /* istanbul ignore else */

      if (cache[_this.sourceList[i]] === true) {
        _this.state = {
          currentIndex: i,
          isLoading: false,
          isLoaded: true
        };
        return _possibleConstructorReturn(_this);
      }
    }

    _this.state = _this.sourceList.length ? // 'normal' opperation: start at 0 and try to load
    {
      currentIndex: 0,
      isLoading: true,
      isLoaded: false
    } : // if we dont have any sources, jump directly to unloaded
    {
      isLoading: false,
      isLoaded: false
    };
    return _this;
  }

  _createClass(Img, [{
    key: "componentDidMount",
    value: function componentDidMount() {
      // kick off process

      /* istanbul ignore else */
      if (this.state.isLoading) this.loadImg();
    }
  }, {
    key: "componentWillUnmount",
    value: function componentWillUnmount() {
      // ensure that we dont leave any lingering listeners

      /* istanbul ignore else */
      if (this.i) this.unloadImg();
    }
  }, {
    key: "UNSAFE_componentWillReceiveProps",
    value: function UNSAFE_componentWillReceiveProps(nextProps) {
      var _this2 = this;

      this.loaderContainer = nextProps.loaderContainer || nextProps.container;
      this.unloaderContainer = nextProps.unloaderContainer || nextProps.container;
      var src = this.srcToArray(nextProps.src);
      var srcAdded = src.filter(function (s) {
        return _this2.sourceList.indexOf(s) === -1;
      });
      var srcRemoved = this.sourceList.filter(function (s) {
        return src.indexOf(s) === -1;
      }); // if src prop changed, restart the loading process

      if (srcAdded.length || srcRemoved.length) {
        this.sourceList = src; // if we dont have any sources, jump directly to unloader

        if (!src.length) return this.setState({
          isLoading: false,
          isLoaded: false
        });
        this.setState({
          currentIndex: 0,
          isLoading: true,
          isLoaded: false
        }, this.loadImg);
      }
    }
  }, {
    key: "render",
    value: function render() {
      // set img props as rest
      var _this$props = this.props,
          container = _this$props.container,
          loader = _this$props.loader,
          unloader = _this$props.unloader,
          src = _this$props.src,
          decode = _this$props.decode,
          loaderContainer = _this$props.loaderContainer,
          unloaderContainer = _this$props.unloaderContainer,
          mockImage = _this$props.mockImage,
          rest = _objectWithoutProperties(_this$props, ["container", "loader", "unloader", "src", "decode", "loaderContainer", "unloaderContainer", "mockImage"]); //eslint-disable-line
      // if we have loaded, show img


      if (this.state.isLoaded) {
        var imgProps = _objectSpread({}, {
          src: this.sourceList[this.state.currentIndex]
        }, {}, rest);

        return container(React__default.createElement("img", imgProps));
      } // if we are still trying to load, show img and a loader if requested


      if (!this.state.isLoaded && this.state.isLoading) {
        return loader ? this.loaderContainer(loader) : null;
      } // if we have given up on loading, show a place holder if requested, or nothing

      /* istanbul ignore else */


      if (!this.state.isLoaded && !this.state.isLoading) {
        return unloader ? this.unloaderContainer(unloader) : null;
      }
    }
  }]);

  return Img;
}(React.Component);

_defineProperty(Img, "defaultProps", {
  loader: false,
  unloader: false,
  decode: true,
  src: [],
  // by default, just return what gets sent in. Can be used for advanced rendering
  // such as animations
  container: function container(x) {
    return x;
  }
});

Img.propTypes =  {};

module.exports = Img;
