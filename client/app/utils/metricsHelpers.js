import dig from 'object-dig';

/* Data set operations */

/* Filter data set on a given key & a given set of allowed values
 *  @data:      Array of data point objects - objects must contain a key, passed as `key`
 *  @key:       The key to filter the data set on
 *  @values:    An array of accepted values, each data point object value for `key` must be in this values lit
 */
export function filterKeys(data, key, values) {
  if (values.length === 0)
    return data;

  return data.filter(dataPoint => values.includes(dig(dataPoint, key)));
}

/* Filter data set given a data range
 *  @data:      Array of data point objects - objects must contain `date` key
 *  @from_date: Lower date range value, inclusive
 *  @to_date:   Upper date range value, inclusive
 */
export function filterDates(data, from_date, to_date) {
  console.log('PENDING');
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
