

/*
  Map values object with associations to a 'postable' values object
  Ie: { children: [{ value: 5, label: 'group-01' }] } -> { child_ids: [5] }

  values: the values from the form
  inputKeys: the array of the key(s) from the form to rename
  resultKeys: the parallel array of desired key(s)
 */
export function mapSelectAssociations(values, inputKeys, resultKeys) {
  const result = Object.assign({}, values);

  for (const inputKey of inputKeys)
    delete result[inputKey];

  resultKeys.forEach((resultKey, i) => {
    if (Object.hasOwnProperty.call(values, inputKeys[i]))
      result[resultKey] = Array.isArray(values[inputKeys[i]])
        ? values[inputKeys[i]].map(o => o.value)
        : values[inputKeys[i]].value;
  });

  return result;
}

export function exclude(values, ...excludes) {
  const permittedValues = Object.assign({}, values);

  for (const exclude of excludes)
    delete permittedValues[exclude];

  return permittedValues;
}
