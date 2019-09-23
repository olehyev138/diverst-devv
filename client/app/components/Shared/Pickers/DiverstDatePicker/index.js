import React, { memo } from 'react';
import { compose } from 'redux';
import { withStyles } from '@material-ui/core/styles';
import PropTypes from 'prop-types';

import { DatePicker, KeyboardDatePicker } from '@material-ui/pickers';

const styles = theme => ({
  inlinePickerPopover: {
    '& .MuiPickersToolbar-toolbar': {
      wordBreak: 'initial',
    },
  },
});

export function DiverstDatePicker({ classes, keyboardMode, variant, field, form, disablePast, disableFuture, ...props }) {
  let inlineProps = {};

  // Necessary as there's an issue with the word-break property for the inline variant
  if (variant === 'inline')
    inlineProps = {
      PopoverProps: {
        className: classes.inlinePickerPopover,
      },
    };

  const pickerProps = {
    variant,
    autoOk: true,
    strictCompareDates: true, // Compares time for minDate/maxDate, disablePast/disableFuture, etc.
    disablePast: disablePast && form.touched[field.name],
    disableFuture: disableFuture && form.touched[field.name],
    name: field.name,
    value: field.value,
    helperText: form.errors[field.name],
    error: !!form.errors[field.name],
    onError: (error) => {
      // Handle as a side effect
      if (error !== form.errors[field.name])
        form.setFieldError(field.name, error);
    },
    // If you are using custom validation schema you probably want to pass `true` as third argument
    onChange: (date) => {
      form.setFieldValue(field.name, date, false);
      form.setFieldTouched(field.name, true, false);
    },
    ...inlineProps,
    ...props
  };

  if (keyboardMode)
    return (
      <KeyboardDatePicker
        {...pickerProps}
        format='yyyy/MM/dd'
        mask='____/__/__'
        {...props}
      />
    );

  return (
    <DatePicker
      {...pickerProps}
      {...props}
    />
  );
}

DiverstDatePicker.defaultProps = {
  keyboardMode: false,
};

DiverstDatePicker.propTypes = {
  classes: PropTypes.object,
  keyboardMode: PropTypes.bool,
  variant: PropTypes.string,
  disablePast: PropTypes.bool,
  disableFuture: PropTypes.bool,
  field: PropTypes.object.isRequired,
  form: PropTypes.object.isRequired,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstDatePicker);
