import React, { memo } from 'react';
import { compose } from 'redux';
import { withStyles } from '@material-ui/core/styles';
import PropTypes from 'prop-types';

import { DateTimePicker, KeyboardDateTimePicker } from '@material-ui/pickers';

const styles = theme => ({
  inlinePickerPopover: {
    '& .MuiPickersToolbar-toolbar': {
      wordBreak: 'initial',
    },
  },
});

export function DiverstDateTimePicker({ classes, keyboardMode, variant, field, form, ...props }) {
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
      <KeyboardDateTimePicker
        {...pickerProps}
        format='yyyy/MM/dd hh:mm a'
        mask='____/__/__ __:__ _M'
        {...props}
      />
    );

  return (
    <DateTimePicker
      {...pickerProps}
      {...props}
    />
  );
}

DiverstDateTimePicker.defaultProps = {
  keyboardMode: false,
};

DiverstDateTimePicker.propTypes = {
  classes: PropTypes.object,
  keyboardMode: PropTypes.bool,
  variant: PropTypes.string,
  field: PropTypes.object.isRequired,
  form: PropTypes.object.isRequired,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstDateTimePicker);
