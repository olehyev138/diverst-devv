// Map the possible timezones to make it compatible with select fields
//    If the time zone we are currently mapping is what the user's timezone is set too
//    set the timezone field to be also compatible with select fields
import produce from 'immer';
import dig from 'object-dig';

export const timezoneMap = (timeZones, user, draft) => timeZones.map((element) => {
  if (element[1] === user.time_zone)
    draft.time_zone = { label: element[1], value: element[0] };
  return { label: element[1], value: element[0] };
});

// maps each field to transform select/checkbox field options to an array compatible with the Select Field
export const mapFieldData = fieldData => fieldData.map(fieldDatum => produce(fieldDatum, (draft) => {
  draft.field = splitOptions(fieldDatum.field);
}));

// Takes fields and transforms the options texts in the form of ("Option1\nOption2\nOption3\n")
// and turns it into an array of select field options [{label: "Option1", value: "Option1"}, ...]
export const splitOptions = field => produce(field, (draft) => {
  draft.options = field.options_text
    ? field.options_text.split('\n').filter(o => o).map(o => ({ value: o, label: o }))
    : null;
});

export const mapFieldNames = (item, nameChanges = {}, base = {}) => {
  const toChange = Object.keys(nameChanges);
  toChange.reduce((sum, n) => {
    const parts = n.split('.');
    sum[nameChanges[n]] = dig(...[item, ...parts]);
    return sum;
  }, base);
};

export const mapSelectField = (item, label = 'name', additionalFields = []) => item
  ? { label: item[label], value: item.id, ...additionalFields.reduce((sum, field) => {
    sum[field] = item[field];
    return sum;
  }, {}) }
  : null;
