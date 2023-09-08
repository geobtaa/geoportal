/**
 * @license Highcharts JS v11.1.0 (2023-06-05)
 *
 * Mousewheel zoom module
 *
 * (c) 2023 Askel Eirik Johansson
 *
 * License: www.highcharts.com/license
 */
(function (factory) {
    if (typeof module === 'object' && module.exports) {
        factory['default'] = factory;
        module.exports = factory;
    } else if (typeof define === 'function' && define.amd) {
        define('highcharts/modules/mouse-wheel-zoom', ['highcharts'], function (Highcharts) {
            factory(Highcharts);
            factory.Highcharts = Highcharts;
            return factory;
        });
    } else {
        factory(typeof Highcharts !== 'undefined' ? Highcharts : undefined);
    }
}(function (Highcharts) {
    'use strict';
    var _modules = Highcharts ? Highcharts._modules : {};
    function _registerModule(obj, path, args, fn) {
        if (!obj.hasOwnProperty(path)) {
            obj[path] = fn.apply(null, args);

            if (typeof CustomEvent === 'function') {
                window.dispatchEvent(
                    new CustomEvent(
                        'HighchartsModuleLoaded',
                        { detail: { path: path, module: obj[path] }
                    })
                );
            }
        }
    }
    _registerModule(_modules, 'Extensions/MouseWheelZoom/MouseWheelZoom.js', [_modules['Core/Utilities.js']], function (U) {
        /* *
         *
         *  (c) 2023 Torstein Honsi, Askel Eirik Johansson
         *
         *  License: www.highcharts.com/license
         *
         *  !!!!!!! SOURCE GETS TRANSPILED BY TYPESCRIPT. EDIT TS FILE ONLY. !!!!!!!
         *
         * */
        var addEvent = U.addEvent,
            isObject = U.isObject,
            pick = U.pick,
            defined = U.defined,
            merge = U.merge;
        /* *
         *
         *  Constants
         *
         * */
        var composedClasses = [],
            defaultOptions = {
                enabled: true,
                sensitivity: 1.1
            };
        /* *
         *
         *  Functions
         *
         * */
        /**
         * @private
         */
        var optionsToObject = function (options) {
                if (!isObject(options)) {
                    return merge(defaultOptions, { enabled: defined(options) ? options : true });
            }
            return merge(defaultOptions, options);
        };
        /**
         * @private
         */
        var fitToBox = function (inner,
            outer) {
                if (inner.x + inner.width > outer.x + outer.width) {
                    if (inner.width > outer.width) {
                        inner.width = outer.width;
                    inner.x = outer.x;
                }
                else {
                    inner.x = outer.x + outer.width - inner.width;
                }
            }
            if (inner.width > outer.width) {
                inner.width = outer.width;
            }
            if (inner.x < outer.x) {
                inner.x = outer.x;
            }
            // y and height
            if (inner.y + inner.height > outer.y + outer.height) {
                if (inner.height > outer.height) {
                    inner.height = outer.height;
                    inner.y = outer.y;
                }
                else {
                    inner.y = outer.y + outer.height - inner.height;
                }
            }
            if (inner.height > outer.height) {
                inner.height = outer.height;
            }
            if (inner.y < outer.y) {
                inner.y = outer.y;
            }
            return inner;
        };
        var wheelTimer,
            originalOptions;
        /**
         * @private
         */
        var zoomBy = function (chart, howMuch, centerXArg, centerYArg, mouseX, mouseY, options) {
                var xAxis = chart.xAxis[0], yAxis = chart.yAxis[0], type = pick(options.type, chart.options.chart.zooming.type, 'x'), zoomX = /x/.test(type), zoomY = /y/.test(type);
            if (defined(xAxis.max) && defined(xAxis.min) &&
                defined(yAxis.max) && defined(yAxis.min) &&
                defined(xAxis.dataMax) && defined(xAxis.dataMin) &&
                defined(yAxis.dataMax) && defined(yAxis.dataMin)) {
                if (zoomY) {
                    // Options interfering with yAxis zoom by setExtremes() returning
                    // integers by default.
                    if (defined(wheelTimer)) {
                        clearTimeout(wheelTimer);
                    }
                    var _a = yAxis.options,
                        startOnTick = _a.startOnTick,
                        endOnTick = _a.endOnTick;
                    if (!originalOptions) {
                        originalOptions = { startOnTick: startOnTick, endOnTick: endOnTick };
                    }
                    if (startOnTick || endOnTick) {
                        yAxis.setOptions({ startOnTick: false, endOnTick: false });
                    }
                    wheelTimer = setTimeout(function () {
                        if (originalOptions) {
                            yAxis.setOptions(originalOptions);
                            // Set the extremes to the same as they already are, but now
                            // with the original startOnTick and endOnTick. We need
                            // `forceRedraw` otherwise it will detect that the values
                            // haven't changed. We do not use a simple yAxis.update()
                            // because it will destroy the ticks and prevent animation.
                            var _a = yAxis.getExtremes(),
                                min = _a.min,
                                max = _a.max;
                            yAxis.forceRedraw = true;
                            yAxis.setExtremes(min, max);
                            originalOptions = void 0;
                        }
                    }, 400);
                }
                if (chart.inverted) {
                    var emulateRoof = yAxis.pos + yAxis.len;
                    // Get the correct values
                    centerXArg = xAxis.toValue(mouseY);
                    centerYArg = yAxis.toValue(mouseX);
                    // Swapping x and y for simplicity when chart is inverted.
                    var tmp = mouseX;
                    mouseX = mouseY;
                    mouseY = emulateRoof - tmp + yAxis.pos;
                }
                var fixToX = mouseX ? ((mouseX - xAxis.pos) / xAxis.len) : 0.5;
                if (xAxis.reversed && !chart.inverted ||
                    chart.inverted && !xAxis.reversed) {
                    // We are taking into account that xAxis automatically gets
                    // reversed when chart.inverted
                    fixToX = 1 - fixToX;
                }
                var fixToY = 1 - (mouseY ? ((mouseY - yAxis.pos) / yAxis.len) : 0.5);
                if (yAxis.reversed) {
                    fixToY = 1 - fixToY;
                }
                var xRange = xAxis.max - xAxis.min, centerX = pick(centerXArg, xAxis.min + xRange / 2), newXRange = xRange * howMuch, yRange = yAxis.max - yAxis.min, centerY = pick(centerYArg, yAxis.min + yRange / 2), newYRange = yRange * howMuch, newXMin = centerX - newXRange * fixToX, newYMin = centerY - newYRange * fixToY, dataRangeX = xAxis.dataMax - xAxis.dataMin, dataRangeY = yAxis.dataMax - yAxis.dataMin, outerX = xAxis.dataMin - dataRangeX * xAxis.options.minPadding, outerWidth_1 = dataRangeX + dataRangeX * xAxis.options.minPadding +
                        dataRangeX * xAxis.options.maxPadding, outerY = yAxis.dataMin - dataRangeY * yAxis.options.minPadding, outerHeight_1 = dataRangeY + dataRangeY * yAxis.options.minPadding +
                        dataRangeY * yAxis.options.maxPadding, newExt = fitToBox({
                        x: newXMin,
                        y: newYMin,
                        width: newXRange,
                        height: newYRange
                    }, {
                        x: outerX,
                        y: outerY,
                        width: outerWidth_1,
                        height: outerHeight_1
                    }), zoomOut = (newExt.x <= outerX &&
                        newExt.width >=
                            outerWidth_1 &&
                        newExt.y <= outerY &&
                        newExt.height >= outerHeight_1);
                // Zoom
                if (defined(howMuch) && !zoomOut) {
                    if (zoomX) {
                        xAxis.setExtremes(newExt.x, newExt.x + newExt.width, false);
                    }
                    if (zoomY) {
                        yAxis.setExtremes(newExt.y, newExt.y + newExt.height, false);
                    }
                    // Reset zoom
                }
                else {
                    if (zoomX) {
                        xAxis.setExtremes(void 0, void 0, false);
                    }
                    if (zoomY) {
                        yAxis.setExtremes(void 0, void 0, false);
                    }
                }
                chart.redraw(false);
            }
        };
        /**
         * @private
         */
        function onAfterGetContainer() {
            var _this = this;
            var chart = this,
                wheelZoomOptions = optionsToObject(chart.options.chart.zooming.mouseWheel);
            if (wheelZoomOptions.enabled) {
                addEvent(this.container, 'wheel', function (e) {
                    e = _this.pointer.normalize(e);
                    // Firefox uses e.detail, WebKit and IE uses deltaX, deltaY, deltaZ.
                    if (chart.isInsidePlot(e.chartX - chart.plotLeft, e.chartY - chart.plotTop)) {
                        var wheelSensitivity = pick(wheelZoomOptions.sensitivity, 1.1),
                            delta = e.detail || ((e.deltaY || 0) / 120);
                        zoomBy(chart, Math.pow(wheelSensitivity, delta), chart.xAxis[0].toValue(e.chartX), chart.yAxis[0].toValue(e.chartY), e.chartX, e.chartY, wheelZoomOptions);
                    }
                    // prevent page scroll
                    if (e.preventDefault) {
                        e.preventDefault();
                    }
                });
            }
        }
        /**
         * @private
         */
        function compose(ChartClass) {
            if (composedClasses.indexOf(ChartClass) === -1) {
                composedClasses.push(ChartClass);
                addEvent(ChartClass, 'afterGetContainer', onAfterGetContainer);
            }
        }
        /* *
         *
         *  Default Export
         *
         * */
        var MouseWheelZoomComposition = {
                compose: compose
            };
        /* *
         *
         *  API Options
         *
         * */
        /**
         * The mouse wheel zoom is a feature included in Highcharts Stock, but is
         * also available for Highcharts Core as a module. Zooming with the mouse wheel
         * is enabled by default. It can be disabled by setting this option to
         * `false`.
         *
         * @type      {boolean|object}
         * @since 11.1.0
         * @requires  modules/mouse-wheel-zoom
         * @sample    {highcharts} highcharts/mouse-wheel-zoom/enabled
         *            Enable or disable
         * @sample    {highstock} stock/mouse-wheel-zoom/enabled
         *            Enable or disable
         * @apioption chart.zooming.mouseWheel
         */
        /**
         * Zooming with the mouse wheel can be disabled by setting this option to
         * `false`.
         *
         * @type      {boolean}
         * @default   true
         * @since 11.1.0
         * @requires  modules/mouse-wheel-zoom
         * @apioption chart.zooming.mouseWheel.enabled
         */
        /**
         * Adjust the sensitivity of the zoom. Sensitivity of mouse wheel or trackpad
         * scrolling. `1` is no sensitivity, while with `2`, one mouse wheel delta will
         * zoom in `50%`.
         *
         * @type      {number}
         * @default   1.1
         * @since 11.1.0
         * @requires  modules/mouse-wheel-zoom
         * @sample    {highcharts} highcharts/mouse-wheel-zoom/sensitivity
         *            Change mouse wheel zoom sensitivity
         * @sample    {highstock} stock/mouse-wheel-zoom/sensitivity
         *            Change mouse wheel zoom sensitivity
         * @apioption chart.zooming.mouseWheel.sensitivity
         */
        /**
         * Decides in what dimensions the user can zoom scrolling the wheel.
         * Can be one of `x`, `y` or `xy`. If not specified here, it will inherit the
         * type from [chart.zooming.type](chart.zooming.type).
         *
         * Note that particularly with mouse wheel in the y direction, the zoom is
         * affected by the default [yAxis.startOnTick](#yAxis.startOnTick) and
         * [endOnTick]((#yAxis.endOnTick)) settings. In order to respect these settings,
         * the zoom level will adjust after the user has stopped zooming. To prevent
         * this, consider setting `startOnTick` and `endOnTick` to `false`.
         *
         * @type      {string}
         * @default   x
         * @validvalue ["x", "y", "xy"]
         * @since 11.1.0
         * @requires  modules/mouse-wheel-zoom
         * @apioption chart.zooming.mouseWheel.type
         */
        (''); // Keeps doclets above in JS file

        return MouseWheelZoomComposition;
    });
    _registerModule(_modules, 'masters/modules/mouse-wheel-zoom.src.js', [_modules['Core/Globals.js'], _modules['Extensions/MouseWheelZoom/MouseWheelZoom.js']], function (Highcharts, MouseWheelZoom) {

        var G = Highcharts;
        MouseWheelZoom.compose(G.Chart);

    });
}));