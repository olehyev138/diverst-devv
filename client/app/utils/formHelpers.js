import dig from 'object-dig';

export function mapFields(values, keys) {
  const mappedValues = Object.assign({}, values);

  for (const key of keys)
    if (mappedValues[key])
      mappedValues[key] = Array.isArray(mappedValues[key])
        ? mappedValues[key].map(o => o.value)
        : mappedValues[key].value;

  return mappedValues;
}

/*
 * Build & define a initial values object for Formik
 * @object - the object from the server, may be undefined or have null fields
 * @valueSchemas - a object consisting of 'schemas' for each form value
 *   - the key for each schema:
 *      - is how the value will be retrieved from object if defined
 *      - is how  value will be stored in returned values object as default
 *   - ex:
 *     {
 *       description: { default: '' },
 *       children: { default: [], customKey: 'child_ids' }
 *     }
 */
export function buildValues(object, valueSchemas) {
  const values = {};

  for (const [key, valueSchema] of Object.entries(valueSchemas)) {
    const storeKey = dig(valueSchema, 'customKey') || key;
    values[storeKey] = dig(object, key) ? object[key] : valueSchema.default;
  }

  return values;
}

/*
 * Checks if the attributes array exists, is empty, or contains *only* destroyed values objects
 * @attributesArray - the array of values objects to check
 *
 * Destroyed values object looks like:
 *   {
 *     ...,
 *     _destroy: 1
 *   }
 */
export function isAttributesArrayEmpty(attributesArray) {
  /* eslint-disable-next-line no-underscore-dangle */
  return !attributesArray || attributesArray.length <= 0 || attributesArray.every(item => item._destroy === '1');
}
