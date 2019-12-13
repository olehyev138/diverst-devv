/**
 *
 * Event List Item Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Grid, Typography, Hidden,
} from '@material-ui/core';

import KeyboardArrowRightIcon from '@material-ui/icons/KeyboardArrowRight';

import { formatDateTimeString, DateTime } from 'utils/dateTimeHelpers';

const styles = theme => ({
  arrowRight: {
    color: theme.custom.colors.grey,
  },
  divider: {
    color: theme.custom.colors.lightGrey,
    backgroundColor: theme.custom.colors.lightGrey,
    border: 'none',
    height: '1px',
  },
  dateText: {
    fontWeight: 'bold',
  },
});

export function EventListItem(props) {
  const { classes, item } = props;

  return (
    <Grid container spacing={1} justify='space-between' alignItems='center'>
      <Grid item xs>
        <Typography color='primary' variant='h6' component='h2'>
          {item.name}
        </Typography>
        {item.description && (
          <React.Fragment>
            <Typography color='textSecondary'>
              {item.description}
            </Typography>
            <Box pb={1} />
          </React.Fragment>
        )}
        <Box pt={1} />
        <Typography color='textSecondary' variant='subtitle2' className={classes.dateText}>
          {formatDateTimeString(item.start, DateTime.DATETIME_MED)}
        </Typography>
      </Grid>
      <Hidden xsDown>
        <Grid item>
          <KeyboardArrowRightIcon className={classes.arrowRight} />
        </Grid>
      </Hidden>
    </Grid>
  );
}

EventListItem.propTypes = {
  classes: PropTypes.object,
  item: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(EventListItem);
