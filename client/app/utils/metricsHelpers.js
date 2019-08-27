import dig from 'object-dig';

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
