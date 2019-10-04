import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { CircularProgress, Grid } from '@material-ui/core';

const styles = theme => ({
  progress: {
    margin: theme.spacing(8),
  },
});

export function DiverstLoader(props) {
  const { classes, isLoading, children } = props;

  if (isLoading === true)
    return (
      <Grid container justify='center'>
        <Grid item>
          <CircularProgress
            size={50}
            className={classes.progress}
          />
        </Grid>
      </Grid>
    );

  return props.children;
}

DiverstLoader.propTypes = {
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  children: PropTypes.node.isRequired,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstLoader);
