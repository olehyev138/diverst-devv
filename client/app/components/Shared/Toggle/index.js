import React from 'react';
import PropTypes from 'prop-types';

import { Grid } from '@material-ui/core';

import ToggleOption from 'components/Shared/Toggle/ToggleOption/index';
import Select from 'components/Shared/Toggle/Select';

function Toggle(props) {
  let content = <option>--</option>;

  // If we have items, render them
  if (props.values)
    content = props.values.map(value => (
      <ToggleOption key={value} value={value} message={props.messages[value]} />
    ));


  return (
    <Grid container>
      <Grid item xs={6}>
        <Select value={props.value} onChange={props.onToggle}>
          {content}
        </Select>
      </Grid>
    </Grid>
  );
}

Toggle.propTypes = {
  onToggle: PropTypes.func,
  values: PropTypes.array,
  value: PropTypes.string,
  messages: PropTypes.object,
};

export default Toggle;
