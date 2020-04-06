import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import { DateTime } from 'luxon';

const styles = theme => ({
  footer: {
    zIndex: 1,
    backgroundColor: theme.palette.primary.main,
    color: 'white',
  },
});

export function ApplicationFooter(props) {
  const { classes } = props;
  return (
    <div align='center' className={classes.footer}>
      © 2015-
      {DateTime.local().year}
      <span> Diverst. All rights reserved.</span>
    </div>
  );
}

ApplicationFooter.propTypes = {
  classes: PropTypes.object,
};

export default compose(
  withStyles(styles),
  memo,
)(ApplicationFooter);
