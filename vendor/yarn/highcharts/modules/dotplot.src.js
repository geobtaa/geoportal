/**
 * @license Highcharts JS v11.1.0 (2023-06-05)
 *
 * Dot plot series type for Highcharts
 *
 * (c) 2010-2021 Torstein Honsi
 *
 * License: www.highcharts.com/license
 */
(function (factory) {
    if (typeof module === 'object' && module.exports) {
        factory['default'] = factory;
        module.exports = factory;
    } else if (typeof define === 'function' && define.amd) {
        define('highcharts/modules/dotplot', ['highcharts'], function (Highcharts) {
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
    _registerModule(_modules, 'Series/DotPlot/DotPlotSeries.js', [_modules['Series/Column/ColumnSeries.js'], _modules['Core/Series/SeriesRegistry.js'], _modules['Core/Utilities.js']], function (ColumnSeries, SeriesRegistry, U) {
        /* *
         *
         *  (c) 2009-2021 Torstein Honsi
         *
         *  Dot plot series type for Highcharts
         *
         *  License: www.highcharts.com/license
         *
         *  !!!!!!! SOURCE GETS TRANSPILED BY TYPESCRIPT. EDIT TS FILE ONLY. !!!!!!!
         *
         * */
        /**
         * @private
         * @todo
         * - Check update, remove etc.
         * - Custom icons like persons, carts etc. Either as images, font icons or
         *   Highcharts symbols.
         */
        const { extend, merge, pick } = U;
        /* *
         *
         *  Class
         *
         * */
        /**
         * @private
         * @class
         * @name Highcharts.seriesTypes.dotplot
         *
         * @augments Highcharts.Series
         */
        class DotPlotSeries extends ColumnSeries {
            constructor() {
                /* *
                 *
                 * Static Properties
                 *
                 * */
                super(...arguments);
                /* *
                 *
                 * Properties
                 *
                 * */
                this.data = void 0;
                this.options = void 0;
                this.points = void 0;
            }
            /* *
             *
             * Functions
             *
             * */
            drawPoints() {
                const series = this, renderer = series.chart.renderer, seriesMarkerOptions = this.options.marker, itemPaddingTranslated = this.yAxis.transA *
                    series.options.itemPadding, borderWidth = this.borderWidth, crisp = borderWidth % 2 ? 0.5 : 1;
                this.points.forEach(function (point) {
                    let yPos, attr, graphics, pointAttr, pointMarkerOptions = point.marker || {}, symbol = (pointMarkerOptions.symbol ||
                        seriesMarkerOptions.symbol), radius = pick(pointMarkerOptions.radius, seriesMarkerOptions.radius), size, yTop, isSquare = symbol !== 'rect', x, y;
                    point.graphics = graphics = point.graphics || [];
                    pointAttr = point.pointAttr ?
                        (point.pointAttr[point.selected ? 'selected' : ''] ||
                            series.pointAttr['']) :
                        series.pointAttribs(point, point.selected && 'select');
                    delete pointAttr.r;
                    if (series.chart.styledMode) {
                        delete pointAttr.stroke;
                        delete pointAttr['stroke-width'];
                    }
                    if (point.y !== null) {
                        if (!point.graphic) {
                            point.graphic = renderer.g('point').add(series.group);
                        }
                        yTop = pick(point.stackY, point.y);
                        size = Math.min(point.pointWidth, series.yAxis.transA - itemPaddingTranslated);
                        let i = Math.floor(yTop);
                        for (yPos = yTop; yPos > yTop - point.y; yPos--, i--) {
                            x = point.barX + (isSquare ?
                                point.pointWidth / 2 - size / 2 :
                                0);
                            y = series.yAxis.toPixels(yPos, true) +
                                itemPaddingTranslated / 2;
                            if (series.options.crisp) {
                                x = Math.round(x) - crisp;
                                y = Math.round(y) + crisp;
                            }
                            attr = {
                                x: x,
                                y: y,
                                width: Math.round(isSquare ? size : point.pointWidth),
                                height: Math.round(size),
                                r: radius
                            };
                            let graphic = graphics[i];
                            if (graphic) {
                                graphic.animate(attr);
                            }
                            else {
                                graphic = renderer.symbol(symbol)
                                    .attr(extend(attr, pointAttr))
                                    .add(point.graphic);
                            }
                            graphic.isActive = true;
                            graphics[i] = graphic;
                        }
                    }
                    graphics.forEach((graphic, i) => {
                        if (!graphic) {
                            return;
                        }
                        if (!graphic.isActive) {
                            graphic.destroy();
                            graphics.splice(i, 1);
                        }
                        else {
                            graphic.isActive = false;
                        }
                    });
                });
            }
        }
        DotPlotSeries.defaultOptions = merge(ColumnSeries.defaultOptions, {
            itemPadding: 0.2,
            marker: {
                symbol: 'circle',
                states: {
                    hover: {},
                    select: {}
                }
            }
        });
        extend(DotPlotSeries.prototype, {
            markerAttribs: void 0
        });
        SeriesRegistry.registerSeriesType('dotplot', DotPlotSeries);
        /* *
         *
         * Default Export
         *
         * */

        return DotPlotSeries;
    });
    _registerModule(_modules, 'masters/modules/dotplot.src.js', [], function () {


    });
}));