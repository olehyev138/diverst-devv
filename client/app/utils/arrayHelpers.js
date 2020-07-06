export const insertIntoArray = (arr, value, prepend = false, append = false) => arr.reduce((result, element, index, array) => {
  if (index === 0 && prepend)
    result.push(value);

  result.push(element);

  if (index < array.length - 1 || append)
    result.push(value);

  return result;
}, []);

function defaultCompare(a, b) {
  return a === b;
}

export const intersection = (arr1, arr2, f = defaultCompare) => arr1.filter(x => arr2.find(y => f(x, y)));

export const difference = (arr1, arr2, f = defaultCompare) => arr1.filter(x => !arr2.find(y => f(x, y)));

export const union = (arr1, arr2, f = defaultCompare) => arr1.concat(difference(arr2, arr1, f));

export const symmetricDifference = (arr1, arr2, f = defaultCompare) => arr1
  .filter(x => !arr2.find(y => f(x, y)))
  .concat(arr2.filter(x => !arr1.find(y => f(x, y))));
