export function objectMap(object, valueMap, keyMap = a => a) {
  return Object.fromEntries(
    Object.entries(object).map(([key, value]) => [keyMap(key), valueMap(value)])
  );
}
