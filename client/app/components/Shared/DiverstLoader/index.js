import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { CircularProgress, Grid, Slide } from '@material-ui/core';

const styles = theme => ({
  progress: {
    margin: theme.spacing(8),
  },
});

export function DiverstLoader(props) {
  const { classes, isLoading, transitionProps, children } = props;

  return (
    <React.Fragment>
      <Slide direction='left' in={!isLoading} mountOnEnter unmountOnExit {...transitionProps}>
        <div>
          {props.children}
        </div>
      </Slide>

      {isLoading ? (
        <Grid container justify='center'>
          <Grid item>
            <CircularProgress
              size={80}
              thickness={1.5}
              className={classes.progress}
            />
          </Grid>
        </Grid>
      ) : undefined}
    </React.Fragment>
  );
}

DiverstLoader.propTypes = {
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  transitionProps: PropTypes.object,
  children: PropTypes.node.isRequired,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstLoader);
