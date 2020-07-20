import dig from 'object-dig';
import { floatRound } from 'utils/floatRound';

// List of Currency value label pairs for select fields
export const currencyOptions = Object.freeze([
  { value: 'USD', label: '$ (USD)' },
  { value: 'CAD', label: '$ (CAD)' },
  { value: 'MXN', label: '$ (MXN)' },
  { value: 'EUR', label: '€ (EUR)' },
  { value: 'GBP', label: '£ (GBP)' },
]);

// Used to cache the props used by react-number-format
const currencyLocaleProps = {};

// Used to get the Select Field format from a currency code
export const getCurrency = code => currencyOptions.find(curr => curr.value === code) || { value: code, label: code };

// Used to calculate the keys for the Locale Props
const currPropsKey = (locale, currency) => `${locale}::${currency}`;

// get the Props used for react-number-format, by either reading from the cache hash
// or determines the props based on testing `intl`'s numberFormat method to determine the relevant settings
export const getCurrencyProps = (intl, currency, localeOverride = null) => {
  // THIS IS A HACKY SOLUTION, BUT IT'S THE BEST I GOT SO FAR

  if (!(intl || localeOverride) || !currency)
    return {};

  const locale = localeOverride || intl.locale;
  const key = currPropsKey(locale, currency);
  if (currencyLocaleProps[key])
    return currencyLocaleProps[key];

  const prototype = toCurrencyString(intl, 123456.4444, currency, localeOverride);

  // decimalSeparator
  const [, decimalSeparator] = prototype.match(/56([^0-9]*)44/) || [];

  // decimalPrecision
  const [, lastDigits] = prototype.match(/56[^0-9]*(4?4?4?4?)/) || [];
  const decimalScale = lastDigits.length;

  // groupingStyle
  function thousandsPicker() {
    // 1,23,456
    if (prototype.match(/1([^0-9]*)2/)[1].length > 0)
      return ['lakh', dig(prototype.match(/1([^0-9]+)2/), 1)];
    // 12,3456
    if (prototype.match(/2([^0-9]*)3/)[1].length > 0)
      return ['wan', dig(prototype.match(/2([^0-9]+)3/), 1)];
    // 123,456
    if (prototype.match(/123/) != null)
      return ['thousand', dig(prototype.match(/3([^0-9]+)4/), 1)];
    return ['thousand', ','];
  }

  const [thousandsGroupStyle, thousandSeparator] = thousandsPicker();

  // prefix/suffix
  const [, prefix] = prototype.match(/^([^\d]*)[\d]/) || [];
  const [, suffix] = prototype.match(/[\d]([^\d]*)$/) || [];

  const numberProps = Object.freeze({ decimalSeparator, decimalScale, thousandsGroupStyle, prefix, suffix, thousandSeparator });
  currencyLocaleProps[key] = numberProps;
  return numberProps;
};

// simple wrapper for `intl`'s getNumberFormat method used to format currency values
export const toCurrencyString = (intl, amount, currency = 'USD', localeOverride = null) => intl
  ? intl.formatters.getNumberFormat(localeOverride || intl.locale, { style: 'currency', currency }).format(amount)
  : new Intl.NumberFormat(localeOverride, { style: 'currency', currency }).format(amount);
