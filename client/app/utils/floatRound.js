export function floatRound(number, rounding) {
  return toNumber(number).toFixed(rounding);
}

export function percent(num, dem) {
  const fraction = toNumber(num) / toNumber(dem);
  const percent = Math.round(fraction * 100);

  if (percent === 0 && fraction > 0)
    return 1;
  if (percent === 100 && fraction < 1)
    return 99;
  return percent;
}

export function toNumber(number) {
  if (number == null)
    return 0;
  if (typeof number === 'string' || number instanceof String)
    return parseFloat(number);
  if (typeof number !== 'number')
    throw new Error(`Not a Number (${number})`);
  return number;
}
