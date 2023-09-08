/* *
 *
 *  (c) 2010-2021 Torstein Honsi
 *
 *  License: www.highcharts.com/license
 *
 *  !!!!!!! SOURCE GETS TRANSPILED BY TYPESCRIPT. EDIT TS FILE ONLY. !!!!!!!
 *
 * */
'use strict';
import BoxPlotSeries from '../BoxPlot/BoxPlotSeries.js';
import ColumnSeries from '../Column/ColumnSeries.js';
import ErrorBarSeriesDefaults from './ErrorBarSeriesDefaults.js';
import SeriesRegistry from '../../Core/Series/SeriesRegistry.js';
const { arearange: AreaRangeSeries } = SeriesRegistry.seriesTypes;
import U from '../../Core/Utilities.js';
const { addEvent, merge, extend } = U;
/* *
 *
 *  Class
 *
 * */
/**
 * Errorbar series type
 *
 * @private
 * @class
 * @name Highcharts.seriesTypes.errorbar
 *
 * @augments Highcharts.Series
 *
 */
class ErrorBarSeries extends BoxPlotSeries {
    constructor() {
        /* *
         *
         *  Static Properties
         *
         * */
        super(...arguments);
        /* *
         *
         *  Properties
         *
         * */
        this.data = void 0;
        this.options = void 0;
        this.points = void 0;
    }
    /* *
     *
     *  Functions
     *
     * */
    getColumnMetrics() {
        // Get the width and X offset, either on top of the linked series
        // column or standalone
        return ((this.linkedParent && this.linkedParent.columnMetrics) ||
            ColumnSeries.prototype.getColumnMetrics.call(this));
    }
    drawDataLabels() {
        const valKey = this.pointValKey;
        if (AreaRangeSeries) {
            AreaRangeSeries.prototype.drawDataLabels.call(this);
            // Arearange drawDataLabels does not reset point.y to high,
            // but to low after drawing (#4133)
            this.data.forEach(function (point) {
                point.y = point[valKey];
            });
        }
    }
    toYData(point) {
        // return a plain array for speedy calculation
        return [point.low, point.high];
    }
}
ErrorBarSeries.defaultOptions = merge(BoxPlotSeries.defaultOptions, ErrorBarSeriesDefaults);
addEvent(ErrorBarSeries, 'afterTranslate', function () {
    this.points.forEach((point) => {
        point.plotLow = point.plotY;
    });
}, { order: 0 });
extend(ErrorBarSeries.prototype, {
    // pointClass: ErrorBarPoint, // just a declaration
    pointArrayMap: ['low', 'high'],
    pointValKey: 'high',
    doQuartiles: false
});
SeriesRegistry.registerSeriesType('errorbar', ErrorBarSeries);
/* *
 *
 *  Default Export
 *
 * */
export default ErrorBarSeries;
