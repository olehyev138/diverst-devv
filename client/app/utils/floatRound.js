export function floatRound(number, rounding) {
  if (typeof number === 'string' || number instanceof String)
    // eslint-disable-next-line no-param-reassign
    number = parseFloat(number);
  else if (typeof number !== 'number')
    throw new Error(`Not a Number (${number})`);

  return number.toFixed(rounding);
}
