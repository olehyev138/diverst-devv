export const insertIntoArray = (arr, value, prepend = false, append = false) => arr.reduce((result, element, index, array) => {
  if (index === 0 && prepend)
    result.push(value);

  result.push(element);

  if (index < array.length - 1 || append)
    result.push(value);

  return result;
}, []);
