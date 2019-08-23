
/*
 * Take data list, current page, total count & return a Promise object for MaterialTable
 *  - @data   - the current page of data to be displayed in the table - must be an array
 *  - @page   - the current page
 *  - @count  - the total number of objects
 */
function buildDataFunction(data, page, count) {
  return query => new Promise((resolve, reject) => resolve(
    { data, page, totalCount: count || 0 }
  ));
}

export default buildDataFunction;
