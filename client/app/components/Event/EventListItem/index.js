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
import DiverstImg from 'components/Shared/DiverstImg';
import ShareIcon from '@material-ui/icons/Share';
import DiverstHTMLEmbedder from 'components/Shared/DiverstHTMLEmbedder';

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
  const { classes, item, currentGroupID } = props;

  return (
    <Grid container spacing={2} justify='space-between' alignItems='center'>
      {item.picture_data && (
        <React.Fragment>
          <Hidden xsDown>
            <Grid item xs='auto'>
              <DiverstImg
                data={item.picture_data}
                contentType={item.picture_content_type}
                maxWidth='90px'
                maxHeight='90px'
                minWidth='90px'
                minHeight='90px'
              />
            </Grid>
          </Hidden>
        </React.Fragment>
      )}
      <Grid item xs>
        <Typography color='primary' variant='h6' component='h2'>
          {item.name}
          &ensp;
          {currentGroupID && item.group_id !== currentGroupID && <ShareIcon />}
        </Typography>
        <hr className={classes.divider} />
        {item.description && (
          <React.Fragment>
            <DiverstHTMLEmbedder
              html={item.description}
              gridProps={{
                alignItems: 'flex-start',
              }}
            />
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
  currentGroupID: PropTypes.number
};

export default compose(
  memo,
  withStyles(styles),
)(EventListItem);
