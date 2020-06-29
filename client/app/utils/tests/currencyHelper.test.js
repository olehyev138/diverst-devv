/**
 * Test injectors
 */

import React from 'react';
import { getCurrency, getCurrencyProps, toCurrencyString } from 'utils/currencyHelpers';
import ReactDOMServer from 'react-dom/server';
import NumberFormat from 'react-number-format';

const locales = [
  'en-US',
  'en-IN',
  'en-UK',
  'fr-FR',
  'fr-CA',
  'es-US',
  'es-MX',
];

const currencies = [
  'USD',
  'CAD',
  'MXN',
  'EUR',
  'GBP',
  'JPY',
];

const invalidCurrency = 'FAKE';
const invalidLocale = 'abcd';

const values = [
  0.64,
  46.48,
  916.62,
  865.96,
  15460.98,
  260419.01,
  123456.4444,
  14244590.59,
  209316549.53,
  6327824383.77
];

describe('Test Currency Helpers', () => {
  describe('Number Formatting', () => {
    locales.forEach((locale) => {
      describe(`For Locale ${locale}`, () => {
        currencies.forEach((currency) => {
          describe(`With currency ${currency}`, () => {
            values.forEach((value) => {
              const intlString = toCurrencyString(null, value, currency, locale);
              // const intlString = toCurrencyString(null, 1111111111.11, 'USD', 'en-IN')
              it(`\`number-formatting\` props for ${value} should result in ${intlString}`, () => {
                const formatProps = getCurrencyProps(null, currency, locale);
                const formatComponent = <NumberFormat displayType='text' value={value} {...formatProps} />;
                const formatHTML = ReactDOMServer.renderToString(formatComponent);
                const [_, formatString] = formatHTML.match(/<span .*?>(.*)<\/span>/);

                try {
                  expect(formatString).toBe(intlString);
                } catch (err) {
                  err.message = `${err.message}\n\nProps: ${JSON.stringify(formatProps, null, 2)}`;
                  throw err;
                }
              });
            });
          });
        });
      });
    });

    describe('Fake Currencies', () => {
      it('will throw an error', () => {
        expect(() => {
          toCurrencyString(null, (Math.random() * 1000000).toFixed(2), invalidCurrency, locales[0]);
        }).toThrow();
      });
    });
  });

  describe('Getting Select Field', () => {
    describe('Known Currencies', () => {
      [...currencies, invalidCurrency].forEach((currency) => {
        describe(`With currency ${currency}`, () => {
          it('The label should contain the value', () => {
            const select = getCurrency(currency);
            expect(select.label).toContain(select.value);
          });
          it('The value should equal the currency code', () => {
            const select = getCurrency(currency);
            expect(select.value).toBe(currency);
          });
        });
      });
    });
  });
});
