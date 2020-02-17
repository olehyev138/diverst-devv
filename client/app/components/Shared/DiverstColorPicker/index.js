import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles, withTheme } from '@material-ui/core/styles';
import { Popover, FormControl, InputLabel, Input, InputAdornment, IconButton, Box } from '@material-ui/core';
import PaletteIcon from '@material-ui/icons/Palette';

import { TwitterPicker } from 'react-color';

const styles = theme => ({
  paper: {
    overflow: 'visible',
  },
  colorPreviewBox: {
    width: 20,
    height: 20,
    borderRadius: 4,
    borderWidth: 1,
    borderColor: 'rgba(0, 0, 0, 0.2)',
    borderStyle: 'solid',
  },
});

export function DiverstColorPicker(props) {
  const { classes, theme } = props;

  const PICKER_COLORS = TwitterPicker.defaultProps.colors.slice();
  PICKER_COLORS[0] = theme.palette.primary.main;

  const [displayColorPicker, setDisplayColorPicker] = useState(false);
  const [anchorEl, setAnchorEl] = useState(null);
  const [color, setColor] = useState(props.value);

  useEffect(() => {
    setColor(props.value);
  }, [props.value]);

  const handleClick = (event) => {
    setAnchorEl(event.currentTarget);
    setDisplayColorPicker(!displayColorPicker);
  };

  const handleClose = () => {
    setDisplayColorPicker(false);
    setAnchorEl(null);
  };

  const handleChange = (color, event) => {
    const sanitizedColor = sanitizeColor(color.hex);

    setColor(sanitizedColor);
    props.onChange(sanitizedColor);
  };

  const handleInputChange = (event) => {
    const sanitizedColor = sanitizeColor(event.target.value);

    setColor(sanitizedColor);
    props.onChange(sanitizedColor);
  };

  const sanitizeColor = color => color.replace(/[^a-zA-Z0-9]/g, '');

  return (
    <React.Fragment>
      <FormControl {...props.FormControlProps}>
        <InputLabel htmlFor={props.id}>{props.label}</InputLabel>
        <Input
          id={props.id}
          name={props.name}
          type='text'
          value={`#${props.value}`}
          onChange={handleInputChange}
          endAdornment={(
            <InputAdornment position='end'>
              <IconButton
                aria-label='Choose color'
                onClick={handleClick}
              >
                <PaletteIcon />
              </IconButton>
            </InputAdornment>
          )}
          startAdornment={(
            <InputAdornment position='start'>
              <Box className={classes.colorPreviewBox} bgcolor={`#${color}`} />
            </InputAdornment>
          )}
          {...props.InputProps}
        />
      </FormControl>
      <Popover
        id={displayColorPicker ? 'color-picker-popover' : undefined}
        open={displayColorPicker}
        anchorEl={anchorEl}
        onClose={handleClose}
        keepMounted
        disablePortal
        anchorOrigin={{
          vertical: 'center',
          horizontal: 'right',
        }}
        transformOrigin={{
          vertical: 'center',
          horizontal: 'left',
        }}
        PaperProps={{
          className: classes.paper,
        }}
        {...props.PopoverProps}
      >
        <TwitterPicker
          color={color}
          onChange={handleChange}
          colors={PICKER_COLORS}
          triangle='hide'
          {...props.PickerProps}
        />
      </Popover>
    </React.Fragment>
  );
}

DiverstColorPicker.propTypes = {
  classes: PropTypes.object,
  theme: PropTypes.object,
  value: PropTypes.string,
  id: PropTypes.string,
  name: PropTypes.string,
  label: PropTypes.string,
  onChange: PropTypes.func,
  handleColorChanged: PropTypes.func,
  PopoverProps: PropTypes.object,
  InputProps: PropTypes.object,
  PickerProps: PropTypes.object,
  FormControlProps: PropTypes.object,
};

DiverstColorPicker.defaultProps = {
  value: 'FFFFFF'
};

export default compose(
  memo,
  withStyles(styles),
  withTheme,
)(DiverstColorPicker);
