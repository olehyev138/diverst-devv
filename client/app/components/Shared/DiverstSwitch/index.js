import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { FormControlLabel, Switch } from '@material-ui/core';

const styles = theme => ({
});

function DiverstSwitch(props) {
  const {
    value,
    name,
    id,
    color,
    label,
    LabelProps,
    ...rest
  } = props;

  return (
    <React.Fragment>
      <FormControlLabel
        control={(
          <Switch
            checked={value}
            value={name || id || label}
            color={color}
            {...rest}
          />
        )}
        label={label}
        {...LabelProps}
      />
    </React.Fragment>
  );
}

DiverstSwitch.propTypes = {
  name: PropTypes.string,
  id: PropTypes.string,
  value: PropTypes.bool,
  label: PropTypes.string,
  color: PropTypes.string,
  LabelProps: PropTypes.object,
};

DiverstSwitch.defaultProps = {
  color: 'primary'
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstSwitch);
