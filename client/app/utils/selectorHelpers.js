// Map the possible timezones to make it compatible with select fields
//    If the time zone we are currently mapping is what the user's timezone is set too
//    set the timezone field to be also compatible with select fields

export const timezoneMap = (timeZones, user, draft) => timeZones.map((element) => {
  if (element[1] === user.time_zone)
    draft.time_zone = { label: element[1], value: element[0] };
  return { label: element[1], value: element[0] };
});

export const mapSelectField = (item, label = 'name', additionalFields = []) => item
  ? { label: item[label], value: item.id, ...additionalFields.reduce((sum, field) => {
    sum[field] = item[field];
    return sum;
  }, {}) }
  : null;
