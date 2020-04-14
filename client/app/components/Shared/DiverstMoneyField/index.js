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

const styles = theme => ({});

export function DiverstMoneyField(props) {
  const { theme, classes, ...rest } = props;

  return (
    <Grid container spacing={2}>
      <Grid item sm={props.currencyForm ? 10 : 12} xs={12}>
        <DiverstCurrencyTextField
          id={props.id}
          name={props.name}
          margin={props.margin}
          fullWidth={props.fullWidth}
          label={props.label}
          value={props.value}
          onChange={props.onChange}
          disabled={props.disabled}
          numericProps={dig(props, 'currency', 'props')}
          max={props.max}
        />
      </Grid>
      {props.currencyForm && (
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
      )}
    </Grid>
  );
}

DiverstMoneyField.propTypes = {
  id: PropTypes.string,
  name: PropTypes.string,
  label: PropTypes.node,
  onChange: PropTypes.func,
  value: PropTypes.string,
  max: PropTypes.string,

  currency_id: PropTypes.string,
  currency_name: PropTypes.string,
  onCurrencyChange: PropTypes.func,
  currency: PropTypes.object,

  classes: PropTypes.object,
  theme: PropTypes.object,
  isCommitting: PropTypes.bool,
  fullWidth: PropTypes.bool,
  margin: PropTypes.string,
  disabled: PropTypes.bool,
  currencyForm: PropTypes.bool,
};

export default compose(
  withTheme,
  withStyles(styles),
)(DiverstMoneyField);
