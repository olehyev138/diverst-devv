import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import { AppBar } from '@material-ui/core';
import { DateTime } from 'luxon';

const styles = theme => ({
  appBar: {
    top: 'auto',
    bottom: 0,
    zIndex: theme.zIndex.drawer + 1,
  },
});

export function ApplicationFooter(props) {
  const { classes } = props;
  return (
    <AppBar className={classes.appBar}>
      <div align='center'>
        © 2015-
        {DateTime.local().year}
        &ensp;Diverst. All right reserved.
      </div>
    </AppBar>
  );
}

ApplicationFooter.propTypes = {
  classes: PropTypes.object,
};

export default compose(
  withStyles(styles),
  memo,
)(ApplicationFooter);
