/* *
 *
 *  (c) 2009-2023 Highsoft AS
 *
 *  License: www.highcharts.com/license
 *
 *  !!!!!!! SOURCE GETS TRANSPILED BY TYPESCRIPT. EDIT TS FILE ONLY. !!!!!!!
 *
 *  Authors:
 *  - Sophie Bremer
 *
 * */
'use strict';
import DataConnector from './Connectors/DataConnector.js';
import DataPoolDefaults from './DataPoolDefaults.js';
import U from '../Core/Utilities.js';
/* *
 *
 *  Class
 *
 * */
/**
 * Data pool to load connectors on-demand.
 *
 * @private
 * @class
 * @name Data.DataPool
 *
 * @param {Data.DataPoolOptions} options
 * Pool options with all connectors.
 */
class DataPool {
    /* *
     *
     *  Constructor
     *
     * */
    constructor(options = DataPoolDefaults) {
        options.connectors = (options.connectors || []);
        this.options = options;
        this.connectors = {};
    }
    /* *
     *
     *  Functions
     *
     * */
    /**
     * Emits an event on this data pool to all registered callbacks of the given
     * event.
     * @private
     *
     * @param {DataTable.Event} e
     * Event object with event information.
     */
    emit(e) {
        U.fireEvent(this, e.type, e);
    }
    /**
     * Loads the connector.
     *
     * @function Data.DataPool#getConnector
     *
     * @param {string} name
     * Name of the connector.
     *
     * @return {Promise<Data.DataConnector>}
     * Returns the connector.
     */
    getConnector(name) {
        const connector = this.connectors[name];
        if (connector) {
            // already loaded
            return Promise.resolve(connector);
        }
        const connectorOptions = this.getConnectorOptions(name);
        if (connectorOptions) {
            return this.loadConnector(connectorOptions);
        }
        throw new Error(`Connector not found. (${name})`);
    }
    /**
     * Loads the options of the connector.
     *
     * @private
     *
     * @param {string} name
     * Name of the connector.
     *
     * @return {DataPoolConnectorOptions|undefined}
     * Returns the options of the connector, or `undefined` if not found.
     */
    getConnectorOptions(name) {
        const connectors = this.options.connectors;
        for (let i = 0, iEnd = connectors.length; i < iEnd; ++i) {
            if (connectors[i].name === name) {
                return connectors[i];
            }
        }
    }
    /**
     * Loads the connector table.
     *
     * @function Data.DataPool#getConnectorTable
     *
     * @param {string} name
     * Name of the connector.
     *
     * @return {Promise<Data.DataTable>}
     * Returns the connector table.
     */
    getConnectorTable(name) {
        return this
            .getConnector(name)
            .then((connector) => connector.table);
    }
    /**
     * Creates and loads the connector.
     *
     * @private
     *
     * @param {Data.DataPoolConnectorOptions} options
     * Options of connector.
     *
     * @return {Promise<Data.DataConnector>}
     * Returns the connector.
     */
    loadConnector(options) {
        return new Promise((resolve, reject) => {
            this.emit({
                type: 'load',
                options
            });
            const ConnectorClass = DataConnector.types[options.type];
            if (!ConnectorClass) {
                throw new Error(`Connector type not found. (${options.type})`);
            }
            const connector = new ConnectorClass(options.options);
            this.connectors[options.name] = connector;
            // eslint-disable-next-line @typescript-eslint/no-floating-promises
            connector.load().then((connector) => {
                this.emit({
                    type: 'afterLoad',
                    options
                });
                resolve(connector);
            })['catch'](reject);
        });
    }
    /**
     * Registers a callback for a specific event.
     *
     * @function Highcharts.DataPool#on
     *
     * @param {string} type
     * Event type as a string.
     *
     * @param {Highcharts.EventCallbackFunction<Highcharts.DataPool>} callback
     * Function to register for an event callback.
     *
     * @return {Function}
     * Function to unregister callback from the event.
     */
    on(type, callback) {
        return U.addEvent(this, type, callback);
    }
    /**
     * Sets connector options with a specific name.
     *
     * @param {Data.DataPoolConnectorOptions} options
     * Connector options to set.
     */
    setConnectorOptions(options) {
        const connectors = this.options.connectors;
        this.emit({
            type: 'setConnectorOptions',
            options
        });
        for (let i = 0, iEnd = connectors.length; i < iEnd; ++i) {
            if (connectors[i].name === options.name) {
                connectors.splice(i, 1);
                break;
            }
        }
        connectors.push(options);
        this.emit({
            type: 'afterSetConnectorOptions',
            options
        });
    }
}
/* *
 *
 *  Default Export
 *
 * */
export default DataPool;
