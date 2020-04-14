/**
 * Copyright (c) 2019 UNICEF.org
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

import React, { useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import AutoNumeric from 'autonumeric';
import { withStyles, TextField, InputAdornment } from '@material-ui/core';
import { compose } from 'redux';

const styles = theme => ({
  textField: props => ({
    textAlign: props.textAlign || 'right',
  }),
});

export function DiverstCurrencyTextField(props) {
  const [autoNumeric, setAuto] = useState(null);
  let inputRef = 0;

  function getValue() {
    if (!autoNumeric) return undefined;
    const valueMapper = {
      string: numeric => numeric.getNumericString(),
      number: numeric => numeric.getNumber(),
    };
    return valueMapper[props.outputFormat](autoNumeric);
  }

  function callEventHandler(event, eventName) {
    if (!props[eventName]) return;
    props[eventName](event, getValue());
  }

  useEffect(() => {
    const { currencySymbol, ...others } = props;
    const options = {
      allowDecimalPadding: 'floats',
      ...others,
      onChange: undefined,
      onFocus: undefined,
      onBlur: undefined,
      onKeyPress: undefined,
      onKeyUp: undefined,
      onKeyDown: undefined,
      watchExternalChanges: false,
    };
    if (autoNumeric)
      autoNumeric.update(options);
    else if (props.value)
      setAuto(new AutoNumeric(inputRef, props.value, options));

    return () => autoNumeric && autoNumeric.remove();
  }, [
    props.value,
    props.decimalCharacter,
    props.digitGroupSeparator,
    props.decimalPlaces,
  ]);

  useEffect(() => {
    if (autoNumeric)
      autoNumeric.set(getValue());
  }, [getValue()]);

  const {
    classes,
    currencySymbol,
    ...others
  } = props;

  const otherProps = {};

  [
    'id',
    'label',
    'className',
    'autoFocus',
    'variant',
    'style',
    'error',
    'disabled',
    'type',
    'name',
    'defaultValue',
    'tabIndex',
    'fullWidth',
    'rows',
    'rowsMax',
    'select',
    'required',
    'helperText',
    'unselectable',
    'margin',
    'SelectProps',
    'multiline',
    'size',
    'FormHelperTextProps',
    'placeholder',
  ].forEach((prop) => {
    otherProps[prop] = props[prop];
  });


  return (
    <TextField
      inputRef={(ref) => { inputRef = ref; }}
      onChange={e => callEventHandler(e, 'onChange')}
      onFocus={e => callEventHandler(e, 'onFocus')}
      onBlur={e => callEventHandler(e, 'onBlur')}
      onKeyPress={e => callEventHandler(e, 'onKeyPress')}
      onKeyUp={e => callEventHandler(e, 'onKeyUp')}
      onKeyDown={e => callEventHandler(e, 'onKeyDown')}
      InputProps={{
        startAdornment: (
          <InputAdornment position='start'>{currencySymbol}</InputAdornment>
        ),
        className: classes.textField,
      }}
      {...otherProps}
    />
  );
}

DiverstCurrencyTextField.propTypes = {
  classes: PropTypes.object,
  type: PropTypes.oneOf(['text', 'tel', 'hidden']),
  /** The variant to use. */
  variant: PropTypes.string,
  id: PropTypes.string,
  /** The CSS class name of the wrapper element. */
  className: PropTypes.string,
  /** Inline styling for element */
  style: PropTypes.object,
  /** If true, the input element will be disabled. */
  disabled: PropTypes.bool,
  /** The label content. */
  label: PropTypes.string,
  /** Align the numbers in the textField.
   * If you pass the `inputProps` from TextFieldAPI text align won't work.
   * then, you have handle it by className with your own class inside inputProps.
   */
  textAlign: PropTypes.oneOf(['right', 'left', 'center']),
  /** Tab index for the element */
  tabIndex: PropTypes.number,
  /** If true, the input element will be focused during the first mount. */
  autoFocus: PropTypes.bool,
  /** The short hint displayed in the input before the user enters a value. */
  placeholder: PropTypes.string,
  /** value to be enter and display in input */
  value: PropTypes.oneOfType([PropTypes.string, PropTypes.number]),
  /** Callback fired when the value is changed. */
  onChange: PropTypes.func,
  /** Callback fired when focused on element. */
  onFocus: PropTypes.func,
  /** Callback fired on blur. */
  onBlur: PropTypes.func,
  /** Callback fired on key press. */
  onKeyPress: PropTypes.func,
  /** Callback fired on key press. */
  onKeyUp: PropTypes.func,
  /** Callback fired on key press. */
  onKeyDown: PropTypes.func,
  /** Defines the currency symbol string. */
  currencySymbol: PropTypes.string,
  /** Defines what decimal separator character is used. */
  decimalCharacter: PropTypes.string,
  /** Allow to declare an alternative decimal separator which is automatically replaced by `decimalCharacter` when typed. */
  decimalCharacterAlternative: PropTypes.string,
  /** Defines the default number of decimal places to show on the formatted value. */
  decimalPlaces: PropTypes.number,
  /** Defines how many decimal places should be visible when the element is unfocused null. */
  decimalPlacesShownOnBlur: PropTypes.number,
  /** Defines how many decimal places should be visible when the element has the focus. */
  decimalPlacesShownOnFocus: PropTypes.number,
  /** Defines the thousand grouping separator character */
  digitGroupSeparator: PropTypes.string,
  /** Controls the leading zero behavior   */
  leadingZero: PropTypes.oneOf(['allow', 'deny', 'keep']),
  /** maximum value that can be enter */
  maximumValue: PropTypes.string,
  /** minimum value that can be enter */
  minimumValue: PropTypes.string,
  /** placement of the negitive and possitive sign symbols */
  negativePositiveSignPlacement: PropTypes.oneOf(['l', 'r', 'p', 's']),
  /** Defines the negative sign symbol to use   */
  negativeSignCharacter: PropTypes.string,
  /** how the value should be formatted,before storing it */
  outputFormat: PropTypes.oneOf(['string', 'number']),
  /** Defines if the element value should be selected on focus. */
  selectOnFocus: PropTypes.bool,
  /** Defines the positive sign symbol to use. */
  positiveSignCharacter: PropTypes.string,
  /** Defines if the element should be set as read only on initialization. */
  readOnly: PropTypes.bool,
  /** predefined objects are available in <a href="https://www.nodenpm.com/autonumeric/4.5.1/detail.html#predefined-options">AutoNumeric</a> */
  preDefined: PropTypes.object,
};

DiverstCurrencyTextField.defaultProps = {
  type: 'text',
  variant: 'standard',
  currencySymbol: '$',
  outputFormat: 'number',
  textAlign: 'right',
  maximumValue: '10000000000000',
  minimumValue: '-10000000000000',
};

export default compose(
  withStyles(styles),
)(DiverstCurrencyTextField);
