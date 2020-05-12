import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { Card, Typography, TextField, CardContent } from '@material-ui/core';
import RichTextEditor from 'react-rte';

export class DiverstRichTextInput2 extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      value: RichTextEditor.createEmptyValue()
    };
  }

  onChange = (value) => {
    this.setState({ value });
    if (this.props.onChange)
      this.props.onChange(
        value.toString('html')
      );
  };

  render() {
    return (
      <div>
        <RichTextEditor
          value={this.state.value}
          onChange={this.onChange}
        />
      </div>
    );
  }
}

DiverstRichTextInput2.propTypes = {
  classes: PropTypes.object,
  onChange: PropTypes.func,
  label: PropTypes.oneOfType([PropTypes.string, PropTypes.element]),
};

export default DiverstRichTextInput2;
