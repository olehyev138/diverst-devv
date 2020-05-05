import dig from 'object-dig';
import { DateTime } from 'luxon';

const OPERATIONS = {
  '==': (x, y) => x === y,
  '!=': (x, y) => x !== y,
  '>': (x, y) => x > y,
  '>=': (x, y) => x >= y,
  '<': (x, y) => x < y,
  '<=': (x, y) => x <= y,
  in: (x, y) => y.includes(x)
};

/**
 * Filter data set on a given filter object
 *   @param data:     Array of `data point` objects - [{ key01: 'value01', ... }, ...]
 *   @param filter:   Array of `filter objects`
 *
 *   return:   Returns a filtered array of `data point` objects
 *
 *   A `filter object` describes a `filter operation` to be carried out on a data point in order to determine whether
 *   it should be included in the filter data set
 *
 *   A filter object must be written as follows: { key: <>, value: <>, op: <> }
 *     `key`:   The key inside each data point in the data set, containing the value to be compared
 *     `value`: The literal value to be compared against `key` in each data point
 *     `op`:    The comparison operator to be applied, must be one of the following:
 *              '==', '!=', '>', '>=', '<=', '<', '<=', 'in'
 *
 *   - Filter operations will always be carried out as: `datapoint.key <op> value`
 *   - Each filter object will be applied against the data point, all must be true in order for the data point to be included.
 *   - The `in` operator expects `value` to be an array of literal values, runs <value-array>.includes(datapoint.key)
 */
export function filterData(data, filters) {
  if (!filters.length)
    return data;

  return data.filter((datapoint) => {
    for (const filter of filters)
      if (filter && !OPERATIONS[filter.op](dig(datapoint, filter.key), filter.value))
        return false;

    return true;
  });
}

/** Return callback function to update date filters
 *  @param filters:       Array of filter objects
 *  @param setFilters:    State setter function to set filters
 *
 *  return:         Returns callback function that takes a range & updates the components state filters
 *
 * - For use by graphs with a date range, returns update function given state filter list & setter
 */
export function getUpdateDateFilters(filters, setFilters) {
  return (range) => {
    /* eslint-disable no-param-reassign */
    range = parseDateRange(range);

    if (range.from_date || range.to_date)
      setFilters({
        ...filters, dateFilters: [
          { value: range.from_date, key: 'date', op: '>=' },
          { value: range.to_date, key: 'date', op: '<' }
        ]
      });
    else
      setFilters({ ...filters, dateFilters: [] });
  };
}

/** Parse a date range into DateTime objects for filtering use
 *  @param range: Object in the form: { from_date: <>, to_date: <> }
 *    from_date:    - Lower datetime range value,
 *                  - Optional, if provided must be either a date shorthand value or a valid datetime string
 *    to_date:      - Upper datetime range value
 *                  - Optional, if provided must be a valid datetime string
 *
 *  return: Returns a ISO formatted date range object in the form { from: <>, to_date: <>}
 *
 *    To be a valid date range - from_date must be less then to_date
 *    valid date shorthand values for from_date: 1m, 3m, 6m, 1y, ytd
 */
export function parseDateRange(range) {
  if (!range.from_date && !range.to_date)
    return range;

  // Parse toDate from datetime string if provided, set to current local datetime otherwise
  const toDate = range.to_date.length ? DateTime.fromISO(range.to_date) : DateTime.local();

  // Parse fromDate from either shorthand value or datetime string
  let fromDate = range.from_date;
  switch (fromDate) {
    case '1m':
      fromDate = DateTime.local().minus({ months: 1 });
      break;
    case '3m':
      fromDate = DateTime.local().minus({ months: 3 });
      break;
    case '6m':
      fromDate = DateTime.local().minus({ months: 6 });
      break;
    case '1y':
      fromDate = DateTime.local().minus({ year: 1 });
      break;
    default:
      fromDate = DateTime.fromISO(fromDate);
  }

  return { from_date: fromDate.toISO(), to_date: toDate.toISO() };
}

/**
 * Set a VegaLite spec with given configuration values
 * All base graphs support a _config_ object that allows the graphs to dynamically
 * set certain values in the VegaLite spec.
 * @param spec      - a VegaLite spec
 * @param config    - configuration object to set values in the VegaLite spec
 *
 * Configuration object:
 *   - Graphs that render _base graphs_ pass a configuration object to set the values
 *     in the spec
 *   - For field & axis titles, they should be set in accordance with each encoding
 *     channel used in the base graph.
 *   - The configuration object should be written as follows:
 *
 *      {
 *        <channel>: { field: <field_name>, title: <title_name> }, ...,
 *        title: <title_name>
 *      }
 *
 */
export function setGraphConfig(spec, config) {
  const channels = ['x', 'y', 'color'];

  // set field & title for each encoding channel
  for (const channel of channels)
    if (spec.encoding[channel]) {
      spec.encoding[channel].field = dig(config, channel, 'field');
      spec.encoding[channel].title = dig(config, channel, 'title');
    }
}

/* -------------------------- !! Deprecated !! -------------------------- */

/* Return a function to handle range selector updates */
export function getUpdateRange([params, setParams]) {
  return (range) => {
    const newParams = { ...params, date_range: range };
    setParams(newParams);
  };
}

/* Return function to handle drilldowns */
export function getHandleDrilldown([data, setCurrentData], [isDrilldown, setIsDrilldown]) {
  return (datapoint) => {
    const newData = !isDrilldown
      ? formatBarGraphData(data.find(dp => dp.y === datapoint.y).children.values)
      : data;

    setCurrentData(newData);
    setIsDrilldown(!isDrilldown);
  };
}

/* Swap x & y values to format data for horizontal bar graphs
 * - @data - array of objects like: [{ x: <label>, y: <n> }, ... ]
 */
export function formatBarGraphData(data) {
  if (data)
    return data.map(d => ({ x: d.y, y: d.x, children: dig(d, 'children') || {} }));

  return [];
}

export function selectSeriesValues(data, series) {
  return dig(data, 'series', series, 'values');
}
