import caseHelper from 'utils/caseHelper';
import dig from 'object-dig';
import { floatRound } from 'utils/floatRound';

export const currencyOptions = Object.freeze([
  { value: 'USD', label: '$ (USD)' },
  { value: 'GBP', label: '£ (GBP)' },
]);

export const currencyLocaleProps = {};

export const getCurrency = code => currencyOptions.find(curr => curr.value === code);

export const moneyToString = (amount, decimalDelim = '.', thousandDelim = ',') => {
  if (typeof amount === 'string')
    return amount;
  const main = Math.floor(amount);
  const decimal = amount % main;

  return `${main.toString().replace(/\B(?=(\d{3})+(?!\d))/g, thousandDelim)}${decimalDelim}${decimal}`;
};

const currPropsKey = (locale, currency) => `${locale}::${currency}`;

export const getCurrencyProps = (intl, currency, localeOverride = null) => {
  // THIS IS A HACKY SOLUTION, BUT IT'S THE BEST I GOT SO FAR

  if (!(intl || localeOverride) || !currency)
    return {};

  const locale = localeOverride || intl.locale;
  const key = currPropsKey(locale, currency);
  if (currencyLocaleProps[key])
    return currencyLocaleProps[key];

  const prototype = toCurrencyString(intl, 123456.7812, currency, localeOverride);

  // decimalSeparator
  const decimalSeparator = prototype.match(/56(.*)78/)[1];

  // decimalPrecision
  const lastDigits = prototype.match(/56.+78(1?2?)/)[1];
  const decimalScale = lastDigits.length + 2;

  // groupingStyle
  const lahkCounting = prototype.match(/1(.*)2/)[1].length > 0;
  const wanCounting = prototype.match(/2(.*)3/)[1].length > 0;
  const thousandCounting = prototype.match(/123/) != null;
  const thousandsGroupStyle = caseHelper(
    true,
    [lahkCounting, 'lahk'],
    [wanCounting, 'wan'],
    [thousandCounting, 'thousand'],
  );

  // group seperator
  const thousandSeparator = caseHelper(
    thousandsGroupStyle,
    [['lahk', 'thousand'], () => dig(prototype.match(/3(.+)4/), 1)],
    ['wan', () => dig(prototype.match(/2(.+)3/), 1)],
  );

  // prefix/suffix
  const prefix = prototype.match(/^([^\d]*)[\d]/)[1];
  const suffix = prototype.match(/[\d]([^\d]*)$/)[1];

  const numberProps = Object.freeze({ decimalSeparator, decimalScale, thousandsGroupStyle, prefix, suffix, thousandSeparator });
  currencyLocaleProps[key] = numberProps;
  return numberProps;
};

export const toCurrencyString = (intl, amount, currency = 'USD', localeOverride = null) => intl
  ? intl.formatters.getNumberFormat(localeOverride || intl.locale, { style: 'currency', currency }).format(amount)
  : `$ ${floatRound(amount, 2)}`;
