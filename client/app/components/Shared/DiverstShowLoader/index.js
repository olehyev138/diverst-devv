import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import FormErrorIcon from '@material-ui/icons/SyncProblem';
import { CircularProgress, Grid, Slide, Box } from '@material-ui/core';

const styles = theme => ({
  loader: {
    marginTop: 60,
  },
  errorIcon: {
    fontSize: 80,
  },
});

function DiverstShowLoader(props) {
  const { classes, isLoading, isError, children, disableTransition, TransitionProps, TransitionComponent, TransitionChildComponent, TransitionChildProps } = props;

  const transitionComponentIsDefault = TransitionComponent === Slide;

  const transitionProps = {
    direction: transitionComponentIsDefault ? 'up' : undefined,
    in: transitionComponentIsDefault ? true : undefined,
    appear: transitionComponentIsDefault ? true : undefined,
    ...TransitionProps,
  };

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
          {disableTransition ? children : (
            <TransitionComponent {...transitionProps}>
              <TransitionChildComponent {...TransitionChildProps}>
                {children}
              </TransitionChildComponent>
            </TransitionComponent>
          )}
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
  disableTransition: PropTypes.bool,
  TransitionProps: PropTypes.object,
  TransitionComponent: PropTypes.any,
  TransitionChildProps: PropTypes.object,
  TransitionChildComponent: PropTypes.any,
};

DiverstShowLoader.defaultProps = {
  TransitionComponent: Slide,
  TransitionChildComponent: Box,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstShowLoader);
