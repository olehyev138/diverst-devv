import { DateTime } from 'luxon';
export { DateTime }; // Exported so that Luxon presets are accessible

// Existing Luxon Presets: https://moment.github.io/luxon/docs/manual/formatting.html#presets
// Custom Preset Reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/DateTimeFormat
export const CUSTOM_FORMAT_PRESETS = {
  DATETIME_MED_NO_YEAR: {
    year: undefined,
    month: 'short',
    day: 'numeric',
    hour: 'numeric',
    minute: '2-digit',
    timeZoneName: undefined,
  },
};

// Default format if none is specified to format functions
export const DEFAULT_DATE_TIME_FORMAT = DateTime.DATETIME_SHORT;

// Parses a valid ISO 8601 DateTime string into a Luxon DateTime object
export function parseDateTime(dateTimeString) {
  return DateTime.fromISO(dateTimeString);
}

// Formats a Luxon DateTime object into a human readable string
//
// Optionally choose the format from Luxon's presets (e.g. 'DateTime.DATETIME_FULL'), from a custom
// preset above, or with a DateTimeFormat object using the reference above
export function formatDateTime(dateTimeObject, optionalFormat = DEFAULT_DATE_TIME_FORMAT) {
  return dateTimeObject.toLocaleString(optionalFormat);
}

// Helper method that combines parsing and formatting a date time string
export function formatDateTimeString(dateTimeString, optionalFormat = DEFAULT_DATE_TIME_FORMAT) {
  return formatDateTime(parseDateTime(dateTimeString), optionalFormat);
}
