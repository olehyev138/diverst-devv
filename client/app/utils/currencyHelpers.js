export const currencyOptions = Object.freeze([
  { value: 'USD', label: '$ (USD)', props: { decimalCharacter: '.', decimalPlaces: 2, digitGroupSeparator: ',', currencySymbol: '$' } },
  { value: 'GBP', label: '£ (GBP)', props: { decimalCharacter: ',', decimalPlaces: 2, digitGroupSeparator: ' ', decimalCharacterAlternative: '.', currencySymbol: '£' } },
]);

export const getCurrency = code => currencyOptions.find(curr => curr.value === code);

export const moneyToString = (amount, decimalDelim = '.', thousandDelim = ',') => {
  if (typeof amount === 'string')
    return amount;
  const main = Math.floor(amount);
  const decimal = amount % main;

  return `${main.toString().replace(/\B(?=(\d{3})+(?!\d))/g, thousandDelim)}${decimalDelim}${decimal}`;
};
