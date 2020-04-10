import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { Button, LinearProgress } from '@material-ui/core';

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

function DiverstSubmit(props) {
  const { classes, children, isCommitting, ...rest } = props;
  return (
    <div className={classes.wrapper}>
      <Button
        color='primary'
        type='submit'
        disabled={isCommitting}
        {...rest}
      >
        {children}
      </Button>
      {isCommitting && (
        <LinearProgress className={classes.buttonProgress} />
      )}
    </div>
  );
}

DiverstSubmit.propTypes = {
  classes: PropTypes.object,
  isCommitting: PropTypes.bool,
  children: PropTypes.any,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstSubmit);
