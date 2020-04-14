import React from 'react';
import PropTypes from 'prop-types';
import { withStyles, TextField, InputAdornment } from '@material-ui/core';
import { compose } from 'redux';
import NumberFormat from 'react-number-format';
import { clamp } from 'utils/floatRound';

const styles = theme => ({});

export function Currency({ inputRef, numericProps, onChange, name, max, ...others }) {
  return (
    <NumberFormat
      getInputRef={inputRef}
      onValueChange={values => onChange(Math.min(values.value, max || Infinity).toString())}
      fixedDecimalScale
      allowNegative={false}
      {...numericProps}
      {...others}
    />
  );
}

Currency.propTypes = {
  numericProps: PropTypes.shape({
    decimalSeparator: PropTypes.oneOfType([PropTypes.bool, PropTypes.string]),
    thousandSeparator: PropTypes.oneOfType([PropTypes.bool, PropTypes.string]),
    decimalScale: PropTypes.number,
    currencySymbol: PropTypes.string,
    thousandsGroupStyle: PropTypes.oneOf(['thousand', 'lakh', 'wan']),
  }),
  onChange: PropTypes.func.isRequired,
  name: PropTypes.string.isRequired,
  inputRef: PropTypes.func.isRequired,
  max: PropTypes.string,
};

export function DiverstCurrencyTextField({ id, value, label, onChange, name, numericProps, max, ...others }) {
  return (
    <TextField
      label={label}
      value={value}
      onChange={onChange}
      name={name}
      id={id}
      InputProps={{
        inputComponent: Currency,
      }}
      // eslint-disable-next-line react/jsx-no-duplicate-props
      inputProps={{
        numericProps,
        max,
      }}
      {...others}
    />
  );
}

DiverstCurrencyTextField.propTypes = {
  numericProps: PropTypes.shape({
    decimalSeparator: PropTypes.oneOfType([PropTypes.bool, PropTypes.string]),
    thousandSeparator: PropTypes.oneOfType([PropTypes.bool, PropTypes.string]),
    decimalScale: PropTypes.number,
    currencySymbol: PropTypes.string,
    thousandsGroupStyle: PropTypes.oneOf(['thousand', 'lakh', 'wan']),
  }),
  onChange: PropTypes.func.isRequired,
  name: PropTypes.string.isRequired,
  id: PropTypes.string.isRequired,
  value: PropTypes.string,
  label: PropTypes.oneOfType([PropTypes.string, PropTypes.node]),
  max: PropTypes.string,
};

export default compose(
  withStyles(styles),
)(DiverstCurrencyTextField);
