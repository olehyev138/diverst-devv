export const currencyOptions = Object.freeze([
  { value: 'USD', label: '$ (USD)', props: { decimalSeparator: '.', decimalScale: 2, thousandSeparator: ',', prefix: '$', thousandsGroupStyle: 'thousand' } },
  { value: 'GBP', label: '£ (GBP)', props: { decimalSeparator: ',', decimalScale: 2, thousandSeparator: ' ', prefix: '£', thousandsGroupStyle: 'thousand' } },
]);

export const getCurrency = code => currencyOptions.find(curr => curr.value === code);

export const moneyToString = (amount, decimalDelim = '.', thousandDelim = ',') => {
  if (typeof amount === 'string')
    return amount;
  const main = Math.floor(amount);
  const decimal = amount % main;

  return `${main.toString().replace(/\B(?=(\d{3})+(?!\d))/g, thousandDelim)}${decimalDelim}${decimal}`;
};
