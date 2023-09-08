var _jsxFileName = "/Users/pjreed/dev/mirador/dist/es/src/components/SearchPanelControls.js";

function _classCallCheck(instance, Constructor) { if (!(instance instanceof Constructor)) { throw new TypeError("Cannot call a class as a function"); } }

function _defineProperties(target, props) { for (var i = 0; i < props.length; i++) { var descriptor = props[i]; descriptor.enumerable = descriptor.enumerable || false; descriptor.configurable = true; if ("value" in descriptor) descriptor.writable = true; Object.defineProperty(target, descriptor.key, descriptor); } }

function _createClass(Constructor, protoProps, staticProps) { if (protoProps) _defineProperties(Constructor.prototype, protoProps); if (staticProps) _defineProperties(Constructor, staticProps); return Constructor; }

function _inherits(subClass, superClass) { if (typeof superClass !== "function" && superClass !== null) { throw new TypeError("Super expression must either be null or a function"); } subClass.prototype = Object.create(superClass && superClass.prototype, { constructor: { value: subClass, writable: true, configurable: true } }); if (superClass) _setPrototypeOf(subClass, superClass); }

function _setPrototypeOf(o, p) { _setPrototypeOf = Object.setPrototypeOf || function _setPrototypeOf(o, p) { o.__proto__ = p; return o; }; return _setPrototypeOf(o, p); }

function _createSuper(Derived) { return function () { var Super = _getPrototypeOf(Derived), result; if (_isNativeReflectConstruct()) { var NewTarget = _getPrototypeOf(this).constructor; result = Reflect.construct(Super, arguments, NewTarget); } else { result = Super.apply(this, arguments); } return _possibleConstructorReturn(this, result); }; }

function _possibleConstructorReturn(self, call) { if (call && (typeof call === "object" || typeof call === "function")) { return call; } return _assertThisInitialized(self); }

function _assertThisInitialized(self) { if (self === void 0) { throw new ReferenceError("this hasn't been initialised - super() hasn't been called"); } return self; }

function _isNativeReflectConstruct() { if (typeof Reflect === "undefined" || !Reflect.construct) return false; if (Reflect.construct.sham) return false; if (typeof Proxy === "function") return true; try { Date.prototype.toString.call(Reflect.construct(Date, [], function () {})); return true; } catch (e) { return false; } }

function _getPrototypeOf(o) { _getPrototypeOf = Object.setPrototypeOf ? Object.getPrototypeOf : function _getPrototypeOf(o) { return o.__proto__ || Object.getPrototypeOf(o); }; return _getPrototypeOf(o); }

function ownKeys(object, enumerableOnly) { var keys = Object.keys(object); if (Object.getOwnPropertySymbols) { var symbols = Object.getOwnPropertySymbols(object); if (enumerableOnly) symbols = symbols.filter(function (sym) { return Object.getOwnPropertyDescriptor(object, sym).enumerable; }); keys.push.apply(keys, symbols); } return keys; }

function _objectSpread(target) { for (var i = 1; i < arguments.length; i++) { var source = arguments[i] != null ? arguments[i] : {}; if (i % 2) { ownKeys(Object(source), true).forEach(function (key) { _defineProperty(target, key, source[key]); }); } else if (Object.getOwnPropertyDescriptors) { Object.defineProperties(target, Object.getOwnPropertyDescriptors(source)); } else { ownKeys(Object(source)).forEach(function (key) { Object.defineProperty(target, key, Object.getOwnPropertyDescriptor(source, key)); }); } } return target; }

function _defineProperty(obj, key, value) { if (key in obj) { Object.defineProperty(obj, key, { value: value, enumerable: true, configurable: true, writable: true }); } else { obj[key] = value; } return obj; }

function _objectWithoutProperties(source, excluded) { if (source == null) return {}; var target = _objectWithoutPropertiesLoose(source, excluded); var key, i; if (Object.getOwnPropertySymbols) { var sourceSymbolKeys = Object.getOwnPropertySymbols(source); for (i = 0; i < sourceSymbolKeys.length; i++) { key = sourceSymbolKeys[i]; if (excluded.indexOf(key) >= 0) continue; if (!Object.prototype.propertyIsEnumerable.call(source, key)) continue; target[key] = source[key]; } } return target; }

function _objectWithoutPropertiesLoose(source, excluded) { if (source == null) return {}; var target = {}; var sourceKeys = Object.keys(source); var key, i; for (i = 0; i < sourceKeys.length; i++) { key = sourceKeys[i]; if (excluded.indexOf(key) >= 0) continue; target[key] = source[key]; } return target; }

import React, { Component } from 'react';
import deburr from 'lodash/deburr';
import debounce from 'lodash/debounce';
import Downshift from 'downshift';
import CircularProgress from '@material-ui/core/CircularProgress';
import TextField from '@material-ui/core/TextField';
import FormControl from '@material-ui/core/FormControl';
import SearchIcon from '@material-ui/icons/SearchSharp';
import InputAdornment from '@material-ui/core/InputAdornment';
import Paper from '@material-ui/core/Paper';
import MenuItem from '@material-ui/core/MenuItem';
import MiradorMenuButton from '../containers/MiradorMenuButton';
import SearchPanelNavigation from '../containers/SearchPanelNavigation';
/** */

function renderInput(inputProps) {
  var InputProps = inputProps.InputProps,
      classes = inputProps.classes,
      ref = inputProps.ref,
      other = _objectWithoutProperties(inputProps, ["InputProps", "classes", "ref"]);

  return /*#__PURE__*/React.createElement(TextField, Object.assign({
    InputProps: _objectSpread({
      classes: {
        input: classes.inputInput,
        root: classes.inputRoot
      },
      inputRef: ref
    }, InputProps)
  }, other, {
    __self: this,
    __source: {
      fileName: _jsxFileName,
      lineNumber: 26,
      columnNumber: 5
    }
  }));
}
/** */


function renderSuggestion(suggestionProps) {
  var suggestion = suggestionProps.suggestion,
      index = suggestionProps.index,
      itemProps = suggestionProps.itemProps,
      highlightedIndex = suggestionProps.highlightedIndex,
      selectedItem = suggestionProps.selectedItem;
  var isHighlighted = highlightedIndex === index;
  var isSelected = (selectedItem || '').indexOf(suggestion.match) > -1;
  return /*#__PURE__*/React.createElement(MenuItem, Object.assign({}, itemProps, {
    key: suggestion.match,
    selected: isHighlighted,
    component: "div",
    style: {
      fontWeight: isSelected ? 500 : 400
    },
    __self: this,
    __source: {
      fileName: _jsxFileName,
      lineNumber: 49,
      columnNumber: 5
    }
  }), suggestion.match);
}

/** */
export var SearchPanelControls = /*#__PURE__*/function (_Component) {
  _inherits(SearchPanelControls, _Component);

  var _super = _createSuper(SearchPanelControls);

  /** */
  function SearchPanelControls(props) {
    var _this;

    _classCallCheck(this, SearchPanelControls);

    _this = _super.call(this, props);
    _this.state = {
      search: props.query,
      selectOpen: props.selectOpen,
      suggestions: []
    };
    _this.handleChange = _this.handleChange.bind(_assertThisInitialized(_this));
    _this.submitSearch = _this.submitSearch.bind(_assertThisInitialized(_this));
    _this.getSuggestions = _this.getSuggestions.bind(_assertThisInitialized(_this));
    _this.selectItem = _this.selectItem.bind(_assertThisInitialized(_this));
    _this.fetchAutocomplete = debounce(_this.fetchAutocomplete.bind(_assertThisInitialized(_this)), 500);
    _this.receiveAutocomplete = _this.receiveAutocomplete.bind(_assertThisInitialized(_this));
    return _this;
  }
  /**
   * Set the component's local search state
   * to blank when the query has been cleared
   */


  _createClass(SearchPanelControls, [{
    key: "componentDidUpdate",
    value: function componentDidUpdate(prevProps) {
      var query = this.props.query;

      if (query !== prevProps.query) {
        // We are setting local state directly here ONLY when the query prop (from redux)
        // changed
        this.setState({
          // eslint-disable-line react/no-did-update-set-state
          search: query
        });
      }
    }
    /** */

  }, {
    key: "getSuggestions",
    value: function getSuggestions(value) {
      var _ref = arguments.length > 1 && arguments[1] !== undefined ? arguments[1] : {},
          _ref$showEmpty = _ref.showEmpty,
          showEmpty = _ref$showEmpty === void 0 ? false : _ref$showEmpty;

      var suggestions = this.state.suggestions;
      var inputValue = deburr(value.trim()).toLowerCase();
      var inputLength = inputValue.length;
      return inputLength === 0 && !showEmpty ? [] : suggestions;
    }
    /** */

  }, {
    key: "handleChange",
    value: function handleChange(value) {
      this.setState({
        search: value,
        selectOpen: true,
        suggestions: []
      });
      this.fetchAutocomplete(value);
    }
    /** */

  }, {
    key: "fetchAutocomplete",
    value: function fetchAutocomplete(value) {
      var autocompleteService = this.props.autocompleteService;
      if (!autocompleteService) return;
      if (!value) return;
      fetch("".concat(autocompleteService.id, "?q=").concat(value)).then(function (response) {
        return response.json();
      }).then(this.receiveAutocomplete);
    }
    /** */

  }, {
    key: "receiveAutocomplete",
    value: function receiveAutocomplete(json) {
      this.setState({
        suggestions: json.terms
      });
    }
    /** */

  }, {
    key: "submitSearch",
    value: function submitSearch(event) {
      var _this$props = this.props,
          companionWindowId = _this$props.companionWindowId,
          fetchSearch = _this$props.fetchSearch,
          searchService = _this$props.searchService,
          windowId = _this$props.windowId;
      var search = this.state.search;
      event && event.preventDefault();
      if (!search) return;
      this.setState({
        selectOpen: false
      });
      fetchSearch(windowId, companionWindowId, "".concat(searchService.id, "?q=").concat(search), search);
    }
    /** */

  }, {
    key: "selectItem",
    value: function selectItem(selectedItem) {
      this.setState({
        search: selectedItem,
        selectOpen: false
      });
      this.submitSearch();
    }
    /** */

  }, {
    key: "render",
    value: function render() {
      var _this2 = this;

      var _this$props2 = this.props,
          classes = _this$props2.classes,
          companionWindowId = _this$props2.companionWindowId,
          searchIsFetching = _this$props2.searchIsFetching,
          t = _this$props2.t,
          windowId = _this$props2.windowId;
      var _this$state = this.state,
          search = _this$state.search,
          selectOpen = _this$state.selectOpen;
      var id = "search-".concat(companionWindowId);
      return /*#__PURE__*/React.createElement(React.Fragment, null, /*#__PURE__*/React.createElement("form", {
        onSubmit: this.submitSearch,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 169,
          columnNumber: 9
        }
      }, /*#__PURE__*/React.createElement(FormControl, {
        className: classes.searchInput,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 170,
          columnNumber: 11
        }
      }, /*#__PURE__*/React.createElement(Downshift, {
        id: id,
        inputValue: search,
        isOpen: selectOpen,
        onOuterClick: function onOuterClick() {
          return _this2.setState({
            selectOpen: false
          });
        },
        onSelect: this.selectItem,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 171,
          columnNumber: 13
        }
      }, function (_ref2) {
        var getInputProps = _ref2.getInputProps,
            getItemProps = _ref2.getItemProps,
            getLabelProps = _ref2.getLabelProps,
            getMenuProps = _ref2.getMenuProps,
            highlightedIndex = _ref2.highlightedIndex,
            inputValue = _ref2.inputValue,
            isOpen = _ref2.isOpen,
            selectedItem = _ref2.selectedItem;

        var _getInputProps = getInputProps({
          onChange: function onChange(e) {
            _this2.handleChange(e.target.value);
          },
          onKeyDown: function onKeyDown(e) {
            e.nativeEvent.preventDownshiftDefault = true;
          }
        }),
            onBlur = _getInputProps.onBlur,
            onFocus = _getInputProps.onFocus,
            inputProps = _objectWithoutProperties(_getInputProps, ["onBlur", "onFocus"]);

        return /*#__PURE__*/React.createElement("div", {
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 197,
            columnNumber: 19
          }
        }, renderInput({
          classes: {},
          fullWidth: true,
          InputLabelProps: getLabelProps(),
          InputProps: {
            endAdornment: /*#__PURE__*/React.createElement(InputAdornment, {
              position: "end",
              className: classes.adornmentWrapper,
              __self: _this2,
              __source: {
                fileName: _jsxFileName,
                lineNumber: 204,
                columnNumber: 27
              }
            }, /*#__PURE__*/React.createElement(MiradorMenuButton, {
              "aria-label": t('searchSubmitAria'),
              type: "submit",
              __self: _this2,
              __source: {
                fileName: _jsxFileName,
                lineNumber: 205,
                columnNumber: 29
              }
            }, /*#__PURE__*/React.createElement(SearchIcon, {
              __self: _this2,
              __source: {
                fileName: _jsxFileName,
                lineNumber: 206,
                columnNumber: 31
              }
            })), Boolean(searchIsFetching) && /*#__PURE__*/React.createElement(CircularProgress, {
              className: classes.searchProgress,
              size: 50,
              __self: _this2,
              __source: {
                fileName: _jsxFileName,
                lineNumber: 209,
                columnNumber: 31
              }
            })),
            id: id,
            onBlur: onBlur,
            onFocus: onFocus
          },
          inputProps: inputProps,
          label: t('searchInputLabel')
        }), /*#__PURE__*/React.createElement("div", Object.assign({}, getMenuProps(), {
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 220,
            columnNumber: 21
          }
        }), isOpen ? /*#__PURE__*/React.createElement(Paper, {
          square: true,
          className: classes.suggestions,
          __self: _this2,
          __source: {
            fileName: _jsxFileName,
            lineNumber: 222,
            columnNumber: 25
          }
        }, _this2.getSuggestions(inputValue).map(function (suggestion, index) {
          return renderSuggestion({
            highlightedIndex: highlightedIndex,
            index: index,
            itemProps: getItemProps({
              item: suggestion.match
            }),
            selectedItem: selectedItem,
            suggestion: suggestion
          });
        })) : null));
      }))), /*#__PURE__*/React.createElement(SearchPanelNavigation, {
        windowId: windowId,
        companionWindowId: companionWindowId,
        __self: this,
        __source: {
          fileName: _jsxFileName,
          lineNumber: 243,
          columnNumber: 9
        }
      }));
    }
  }]);

  return SearchPanelControls;
}(Component);
SearchPanelControls.defaultProps = {
  autocompleteService: undefined,
  classes: {},
  query: '',
  selectOpen: undefined,
  t: function t(key) {
    return key;
  }
};