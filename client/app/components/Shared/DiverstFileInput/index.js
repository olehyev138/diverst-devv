import React from 'react';
import { compose } from 'redux';
import { withStyles } from '@material-ui/core/styles';
import PropTypes from 'prop-types';

import { Button, FormControl, FormHelperText, FormLabel, Grid, Typography } from '@material-ui/core';

const styles = theme => ({
  fileInput: {
    display: 'none',
  },
  uploadSection: {
    paddingTop: 8,
  },
  fileName: {
    fontSize: 16,
    verticalAlign: 'middle',
  },
});

const inputRef = React.createRef();

export function DiverstFileInput(props) {
  const { classes, ...rest } = props;

  // Form Control props
  const {
    disabled,
    error,
    fullWidth,
    hiddenLabel,
    margin,
    required,
    variant,
    value,
    ...inputProps
  } = rest;

  return (
    <React.Fragment>
      <FormControl
        disabled={disabled}
        error={error}
        fullWidth={fullWidth}
        hiddenLabel={hiddenLabel}
        margin={margin}
        required={required}
        variant={variant}
      >
        <FormLabel
          htmlFor={props.id}
          disabled={disabled}
          error={error}
          required={required}
        >
          {props.label}
        </FormLabel>
        <input
          accept='image/*'
          id={props.id}
          type='file'
          className={classes.fileInput}
          ref={inputRef}
          {...inputProps}
        />
        <Grid container spacing={2} className={classes.uploadSection} alignItems='center'>
          <Grid item>
            <Button
              component='span'
              color='secondary'
              variant='contained'
              onClick={() => inputRef.current.click()}
            >
              Upload File
            </Button>
          </Grid>
          <Grid item xs>
            {props.value && props.value.name ? (
              <Typography variant='h6' className={classes.fileName} color='textSecondary'>
                {props.value.name}
              </Typography>
            ) : (
              <Typography variant='h6' className={classes.fileName}>
               Nothing attached
              </Typography>
            )}
          </Grid>
        </Grid>
        {props.showHelperText && (
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
    </React.Fragment>
  );
}

DiverstFileInput.propTypes = {
  id: PropTypes.string,
  classes: PropTypes.object,
  label: PropTypes.node,
  value: PropTypes.object,
  helperText: PropTypes.node,
  showHelperText: PropTypes.bool,
};

export default compose(
  withStyles(styles),
)(DiverstFileInput);
