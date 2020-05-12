import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { Typography } from '@material-ui/core';
import RichTextEditor from 'react-rte';

export function DiverstRichTextInput2(props) {
  const { label, ...rest } = props;
  const [value, setValue] = useState(props.value
    ? RichTextEditor.createValueFromString(props.value, 'html')
    : RichTextEditor.createEmptyValue());
  const onChange = (value) => {
    setValue(value);
    if (props.onChange)
      props.onChange(
        value.toString('html')
      );
  };

  return (
    <React.Fragment>
      <Typography variant='h6' color='primary'>
        {label}
      </Typography>
      <RichTextEditor
        value={value}
        onChange={onChange}
      />
    </React.Fragment>
  );
}

DiverstRichTextInput2.propTypes = {
  classes: PropTypes.object,
  onChange: PropTypes.func,
  value: PropTypes.string,
  label: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
};

export default DiverstRichTextInput2;
