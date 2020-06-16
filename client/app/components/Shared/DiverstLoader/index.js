import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { CircularProgress, Grid, Slide } from '@material-ui/core';

const styles = theme => ({
  progress: {
    margin: theme.spacing(8),
    position: 'absolute',
    top: '50%',
    left: '50%',
    marginTop: -12,
    marginLeft: -12,
  },
});

function DiverstLoader(props) {
  const { classes, isLoading, transitionProps, children, noTransition, transition: Transition } = props;
  return (
    <React.Fragment>
      {noTransition ? (
        <div>
          {children}
        </div>
      ) : (
        <Transition direction='left' in={!isLoading} mountOnEnter unmountOnExit {...transitionProps}>
          <div>
            {children}
          </div>
        </Transition>
      )}

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
  noTransition: PropTypes.bool,
  transition: PropTypes.elementType,
};

DiverstLoader.defaultProps = {
  transition: Slide,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstLoader);
