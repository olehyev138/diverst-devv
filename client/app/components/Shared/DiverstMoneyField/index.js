import React from 'react';
import { compose } from 'redux';
import { withStyles, withTheme } from '@material-ui/core/styles';
import PropTypes from 'prop-types';
import dig from 'object-dig';
import Select from 'react-select';

import { Grid, FormHelperText, FormLabel, Input, InputAdornment, InputLabel } from '@material-ui/core';
import { currencyOptions, moneyToString } from 'utils/currencyHelpers';
import DiverstSelect from 'components/Shared/DiverstSelect';
import DiverstCurrencyTextField from 'components/Shared/DiverstCurrencyTextField';

const styles = theme => ({
  formControl: {
    minWidth: 150,
  },
  select: {
    width: '100%',
    paddingTop: 8,
  },
  formLabel: {
    fontSize: '0.9rem',
  },
});

export function DiverstMoneyField(props) {
  const { theme, classes, ...rest } = props;

  return (
    <Grid container spacing={2}>
      <Grid item sm={10} xs={12}>
        <DiverstCurrencyTextField
          id={props.id}
          name={props.name}
          margin={props.margin}
          fullWidth={props.fullWidth}
          label={props.label}
          value={props.value}
          onChange={(_, value) => props.onChange(value)}
          disabled={props.disabled}
          {...dig(props, 'currency', 'props')}

          outputFormat='number'
          maximumValue='1000000000000000'
          minimumValue='0'
        />
      </Grid>
      <Grid item sm={2} xs={12}>
        <DiverstSelect
          id={props.currency_id}
          name={props.currency_name}
          margin={props.margin}
          fullWidth
          options={currencyOptions}
          value={props.currency}
          onChange={props.onCurrencyChange}
          disabled={true || props.disabled}
        />
      </Grid>
    </Grid>
  );
}

DiverstMoneyField.propTypes = {
  id: PropTypes.string,
  currency_id: PropTypes.string,
  classes: PropTypes.object,
  label: PropTypes.node,
  theme: PropTypes.object,
  helperText: PropTypes.node,
  className: PropTypes.string,
  enterprise: PropTypes.object,
  coloredDefault: PropTypes.bool,
  imgClass: PropTypes.string,
  alt: PropTypes.string,
  hideHelperText: PropTypes.bool,

  onChange: PropTypes.func,
  onCurrencyChange: PropTypes.func,
  isCommitting: PropTypes.bool,
  value: PropTypes.number,
  currency: PropTypes.object,
  fullWidth: PropTypes.bool,
  name: PropTypes.string,
  currency_name: PropTypes.string,
  margin: PropTypes.string,
  disabled: PropTypes.bool,
};

export default compose(
  withTheme,
  withStyles(styles),
)(DiverstMoneyField);
