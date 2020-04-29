import React from 'react';
import { compose } from 'redux';
import { withStyles, withTheme } from '@material-ui/core/styles';
import PropTypes from 'prop-types';
import Select from 'react-select';

import { FormControl, FormHelperText, FormLabel } from '@material-ui/core';

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

export function DiverstSelect(props) {
  const { theme, classes, ...rest } = props;

  // Form Control props
  const {
    disabled,
    error,
    fullWidth,
    hiddenLabel,
    margin,
    required,
    variant,
    ...selectProps
  } = rest;

  return (
    <FormControl
      className={classes.formControl}
      disabled={disabled}
      error={error}
      fullWidth={fullWidth}
      hiddenLabel={hiddenLabel}
      margin={margin}
      required={required}
      variant={variant}
    >
      <FormLabel
        className={classes.formLabel}
        htmlFor={props.id}
        disabled={disabled}
        error={error}
        required={required}
      >
        {props.label}
      </FormLabel>
      <Select
        isLoading={props.isLoading}
        className={classes.select}
        // Done to prevent the select menu from being hidden behind other elements
        menuPortalTarget={document.body}
        menuPlacement='auto'
        captureMenuScroll={false}
        aria-describedby={`${props.id}-helper-text`}
        theme={selectTheme => ({
          ...selectTheme,
          colors: {
            ...selectTheme.colors,
            primary: theme.palette.primary.main,
            primary25: theme.palette.primary.main25,
            primary50: theme.palette.primary.main50,
            primary75: theme.palette.primary.main75,
            danger: theme.palette.error.main,
          }
        })}
        {...selectProps}
        isDisabled={disabled}
      />
      {!props.hideHelperText && (
        <FormHelperText
          id={`${props.id}-helper-text`}
          disabled={disabled}
          error={error}
          required={required}
          variant={variant}
        >
          {props.helperText}
        </FormHelperText>
      )}
    </FormControl>
  );
}

DiverstSelect.propTypes = {
  id: PropTypes.string,
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
  isLoading: PropTypes.bool,
};

export default compose(
  withTheme,
  withStyles(styles),
)(DiverstSelect);
