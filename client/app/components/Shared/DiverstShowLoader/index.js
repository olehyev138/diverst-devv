import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import FormErrorIcon from '@material-ui/icons/SyncProblem';
import { CircularProgress, Grid, Slide } from '@material-ui/core';

const styles = theme => ({
  loader: {
    marginTop: 60,
  },
  errorIcon: {
    fontSize: 80,
  },
});

function DiverstShowLoader(props) {
  const { classes, isLoading, isError, children, TransitionProps } = props;

  return (
    <React.Fragment>
      {isLoading || isError ? (
        <Grid container justify='center' alignContent='center' className={classes.loader}>
          <Grid item>
            {isLoading === true ? (
              <CircularProgress size={80} thickness={1.5} />
            ) : (isError === true && (
              <FormErrorIcon color='primary' className={classes.errorIcon} />
            ))}
          </Grid>
        </Grid>
      ) : (
        <React.Fragment>
          <Slide direction='up' in appear {...TransitionProps}>
            <div>
              {children}
            </div>
          </Slide>
        </React.Fragment>
      )}
    </React.Fragment>
  );
}

DiverstShowLoader.propTypes = {
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  isError: PropTypes.bool,
  children: PropTypes.node,
  TransitionProps: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstShowLoader);
