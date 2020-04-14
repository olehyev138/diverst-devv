export function floatRound(number, rounding) {
  return toNumber(number).toFixed(rounding);
}

export function percentMax100(num, dem) {
  const fraction = toNumber(num) / toNumber(dem);
  const percent = Math.round(fraction * 100);

  if (percent === 0 && fraction > 0)
    return 1;
  if (percent === 100 && fraction < 1)
    return 99;
  return clamp(percent, 0, 100);
}

export function percent(num, dem) {
  const fraction = toNumber(num) / toNumber(dem);
  return Math.ceil(fraction * 100);
}

export function clamp(num, min, max) {
  return Math.min(Math.max(num, toNumber(min)), toNumber(max));
}

export function toNumber(number) {
  if (number == null)
    return undefined;
  if (typeof number === 'string' || number instanceof String)
    return parseFloat(number);
  if (typeof number !== 'number')
    throw new Error(`Not a Number (${number})`);
  return number;
}
