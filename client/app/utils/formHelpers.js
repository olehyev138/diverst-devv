import dig from 'object-dig';

/*
  Map values object with associations to a 'postable' values object
  Ie: { children: [{ value: 5, label: 'group-01' }] } -> { child_ids: [5] }

  values: the values from the form
  inputKeys: the array of the key(s) from the form to rename
  resultKeys: the parallel array of desired key(s)
 */
// export function mapSelectAssociations(values, inputKeys, resultKeys) {
//   const result = Object.assign({}, values);
//
//   for (const inputKey of inputKeys)
//     delete result[inputKey];
//
//   resultKeys.forEach((resultKey, i) => {
//     if (Object.hasOwnProperty.call(values, inputKeys[i]))
//       result[resultKey] = Array.isArray(values[inputKeys[i]])
//         ? values[inputKeys[i]].map(o => o.value)
//         : values[inputKeys[i]].value;
//   });
//
//   return result;
// }

export function mapAssociations(values, keys) {
  const mappedValues = Object.assign({}, values);

  for (const key of keys)
    if (mappedValues[key])
      mappedValues[key] = mappedValues[key].map(o => o.value);

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
    const storeKey = dig(valueSchema, 'customKey') ? valueSchema.customKey : key;
    values[storeKey] = dig(object, key) ? object[key] : valueSchema.default;
  }

  return values;
}
