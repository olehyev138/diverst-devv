import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { Button } from '@material-ui/core';
import { useLastLocation } from 'react-router-last-location';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

const styles = theme => ({
  wrapper: {
    position: 'relative',
  },
  buttonProgress: {
    position: 'absolute',
    left: 0,
    right: 0,
    bottom: 0,
    backgroundColor: theme.palette.success.lightBackground,
    '& .MuiLinearProgress-bar': {
      backgroundColor: theme.palette.success.main,
    },
  },
});

// Returns by default to the last location unless there is no previous location
function DiverstCancel(props) {
  const { classes, children, redirectFallback, disabled, component, ...rest } = props;

  const lastLocation = useLastLocation();
  return (
    <Button
      to={(lastLocation && lastLocation.pathname) || redirectFallback}
      disabled={disabled}
      component={component}
      {...rest}
    >
      {children}
    </Button>
  );
}

DiverstCancel.defaultProps = {
  component: WrappedNavLink,
};

DiverstCancel.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
  redirectFallback: PropTypes.string.isRequired,
  disabled: PropTypes.bool,
  component: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstCancel);
