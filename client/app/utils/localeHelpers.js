// Takes a Locale string ('en-US') and turns it into a Locale object (Intl.Locale)
export function getLocaleObjectFromLocaleString(localeString, options = undefined) {
  if (!localeString) return null;

  const locale = new Intl.Locale(localeString, options);
  if (!locale) return null;

  return locale;
}

// Takes a Locale object (Intl.Locale) and turns it into a language string ('en')
export function getLanguageStringFromLocaleObject(localeObject) {
  if (!localeObject) return null;

  return localeObject.language;
}

// Takes a Locale object (Intl.Locale) and turns it into a Locale string  ('en-US')
export function getLocaleStringFromLocaleObject(localeObject) {
  if (!localeObject) return null;

  return localeObject.baseName;
}

// Takes a Locale string ('en-US') and turns it into a language string ('en')
export function getLanguageStringFromLocaleString(localeString, options = undefined) {
  return getLanguageStringFromLocaleObject(getLocaleObjectFromLocaleString(localeString, options));
}
