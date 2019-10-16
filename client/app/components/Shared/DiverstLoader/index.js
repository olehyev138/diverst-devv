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
  const { classes, isLoading, children } = props;

  return (
    <React.Fragment>
      <Slide direction='left' in={!isLoading} mountOnEnter unmountOnExit>
        <div>
          {props.children}
        </div>
      </Slide>

      {isLoading ? (
        <Grid container justify='center'>
          <Grid item>
            <CircularProgress
              size={50}
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
  children: PropTypes.node.isRequired,
};

export default compose(
  memo,
  withStyles(styles),
)(DiverstLoader);
