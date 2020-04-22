export const insertIntoArray = (arr, value) => arr.reduce((result, element, index, array) => {
  result.push(element);
  if (index < array.length - 1)
    result.push(value);
  return result;
}, []);
