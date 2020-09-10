import React, { memo } from 'react';
import { compose } from 'redux';
import { withStyles } from '@material-ui/core/styles';
import PropTypes from 'prop-types';

import { TimePicker, KeyboardTimePicker } from '@material-ui/pickers';
import {IconButton} from "@material-ui/core";
import ClearIcon from "@material-ui/icons/Clear";

const styles = theme => ({
  inlinePickerPopover: {
    '& .MuiPickersToolbar-toolbar': {
      wordBreak: 'initial',
    },
  },
});

export function DiverstTimePicker({ classes, keyboardMode, variant, field, form, disablePast, disableFuture, isClearable, ...props }) {
  let inlineProps = {};
  const InputProps = {};
  const InputAdornmentProps = {};

  // Necessary as there's an issue with the word-break property for the inline variant
  if (variant === 'inline')
    inlineProps = {
      PopoverProps: {
        className: classes.inlinePickerPopover,
      },
    };

  const onError = (error) => {
    // Handle as a side effect
    if (error !== form.errors[field.name])
      form.setFieldError(field.name, error);
  };

  // If you are using custom validation schema you probably want to pass `true` as third argument
  const onChange = (date) => {
    form.setFieldValue(field.name, date, false);
    form.setFieldTouched(field.name, true, false);
  };

  if (isClearable)
    InputProps.startAdornment = (
      <IconButton onClick={() => pickerProps.onChange(null)}>
        <ClearIcon />
      </IconButton>
    );

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
    onError,
    onChange,
    InputProps,
    InputAdornmentProps,
    ...inlineProps,
    ...props
  };

  if (keyboardMode)
    return (
      <KeyboardTimePicker
        {...pickerProps}
        format='hh:mm a'
        mask='__:__ _M'
        {...props}
      />
    );

  return (
    <TimePicker
      {...pickerProps}
      {...props}
    />
  );
}

DiverstTimePicker.defaultProps = {
  keyboardMode: false,
};

DiverstTimePicker.propTypes = {
  classes: PropTypes.object,
  keyboardMode: PropTypes.bool,
  variant: PropTypes.string,
  disablePast: PropTypes.bool,
  disableFuture: PropTypes.bool,
  field: PropTypes.object.isRequired,
  form: PropTypes.object.isRequired,
  isClearable: PropTypes.bool,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstTimePicker);
