import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import FormErrorIcon from '@material-ui/icons/SyncProblem';
import { CircularProgress, Grid, Typography } from '@material-ui/core';

const styles = theme => ({
  formLoader: {
    position: 'absolute',
    top: 0,
    left: 0,
    bottom: 0,
    right: 0,
    zIndex: 1,
  },
  formLoaderWrapper: {
    position: 'relative',
  },
  formLoading: {
    filter: 'brightness(75%) opacity(60%) grayscale(100%)',
  },
  formErrorIcon: {
    fontSize: 80,
  },
});

function DiverstFormLoader(props) {
  const { classes, isLoading, isError, children } = props;

  const dimForm = isLoading === true || isError === true;

  return (
    <React.Fragment>
      <div className={dimForm ? classes.formLoaderWrapper : undefined}>
        {isLoading === true && (
          <Grid container justify='center' alignContent='center' className={classes.formLoader}>
            <Grid item>
              <CircularProgress size={80} thickness={1.5} />
            </Grid>
          </Grid>
        )}
        {!isLoading && isError === true && (
          <Grid container justify='center' alignContent='center' className={classes.formLoader}>
            <Grid item>
              <FormErrorIcon color='primary' className={classes.formErrorIcon} />
            </Grid>
          </Grid>
        )}
        <div className={dimForm || isError === true ? classes.formLoading : undefined}>
          {children}
        </div>
      </div>
    </React.Fragment>
  );
}

DiverstFormLoader.propTypes = {
  classes: PropTypes.object,
  isLoading: PropTypes.bool,
  isError: PropTypes.bool,
  children: PropTypes.node.isRequired,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstFormLoader);
