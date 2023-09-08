"use strict";
/**
 * A set of utility functions that are called by the compiled Javascript
 * functions, these are included locally in the output of {@link MessageFormat.compile compile()}.
 */
Object.defineProperty(exports, "__esModule", { value: true });
exports.reqArgs = exports.select = exports.plural = exports.strictNumber = exports.number = exports._nf = void 0;
/** @private */
function _nf(lc) {
    // eslint-disable-next-line @typescript-eslint/ban-ts-comment
    // @ts-ignore
    return _nf[lc] || (_nf[lc] = new Intl.NumberFormat(lc));
}
exports._nf = _nf;
/**
 * Utility function for `#` in plural rules
 *
 * @param lc The current locale
 * @param value The value to operate on
 * @param offset An offset, set by the surrounding context
 * @returns The result of applying the offset to the input value
 */
function number(lc, value, offset) {
    return _nf(lc).format(value - offset);
}
exports.number = number;
/**
 * Strict utility function for `#` in plural rules
 *
 * Will throw an Error if `value` or `offset` are non-numeric.
 *
 * @param lc The current locale
 * @param value The value to operate on
 * @param offset An offset, set by the surrounding context
 * @param name The name of the argument, used for error reporting
 * @returns The result of applying the offset to the input value
 */
function strictNumber(lc, value, offset, name) {
    var n = value - offset;
    if (isNaN(n))
        throw new Error('`' + name + '` or its offset is not a number');
    return _nf(lc).format(n);
}
exports.strictNumber = strictNumber;
/**
 * Utility function for `{N, plural|selectordinal, ...}`
 *
 * @param value The key to use to find a pluralization rule
 * @param offset An offset to apply to `value`
 * @param lcfunc A locale function from `pluralFuncs`
 * @param data The object from which results are looked up
 * @param isOrdinal If true, use ordinal rather than cardinal rules
 * @returns The result of the pluralization
 */
function plural(value, offset, lcfunc, data, isOrdinal) {
    if ({}.hasOwnProperty.call(data, value))
        return data[value];
    if (offset)
        value -= offset;
    var key = lcfunc(value, isOrdinal);
    return key in data ? data[key] : data.other;
}
exports.plural = plural;
/**
 * Utility function for `{N, select, ...}`
 *
 * @param value The key to use to find a selection
 * @param data The object from which results are looked up
 * @returns The result of the select statement
 */
function select(value, data) {
    return {}.hasOwnProperty.call(data, value) ? data[value] : data.other;
}
exports.select = select;
/**
 * Checks that all required arguments are set to defined values
 *
 * Throws on failure; otherwise returns undefined
 *
 * @param keys The required keys
 * @param data The data object being checked
 */
function reqArgs(keys, data) {
    for (var i = 0; i < keys.length; ++i)
        if (!data || data[keys[i]] === undefined)
            throw new Error("Message requires argument '".concat(keys[i], "'"));
}
exports.reqArgs = reqArgs;
