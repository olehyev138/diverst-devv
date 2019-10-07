/**
 *
 * Events List Component
 *
 */

import React, { memo, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Tab, Paper, Card, CardContent, Grid, Link, Typography, Button, Hidden,
} from '@material-ui/core';

import KeyboardArrowRightIcon from '@material-ui/icons/KeyboardArrowRight';
import AddIcon from '@material-ui/icons/Add';

import { FormattedMessage, injectIntl } from 'react-intl';
import messages from 'containers/Event/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import DiverstPagination from 'components/Shared/DiverstPagination';

import { formatDateTimeString, DateTime } from 'utils/dateTimeHelpers';
import DiverstLoader from 'components/Shared/DiverstLoader';

const styles = theme => ({
  eventListItem: {
    width: '100%',
  },
  arrowRight: {
    color: theme.custom.colors.grey,
  },
  divider: {
    color: theme.custom.colors.lightGrey,
    backgroundColor: theme.custom.colors.lightGrey,
    border: 'none',
    height: '1px',
  },
  eventLink: {
    '&:hover': {
      textDecoration: 'none',
    },
    '&:hover h2': {
      textDecoration: 'underline',
    },
  },
  dateText: {
    fontWeight: 'bold',
  },
  floatRight: {
    float: 'right',
  },
  floatSpacer: {
    display: 'flex',
    width: '100%',
    marginBottom: 24,
  },
});

export function EventsList(props, context) {
  const { classes, intl } = props;

  const routeContext = useContext(RouteContext);

  return (
    <React.Fragment>
      <Button
        className={classes.floatRight}
        variant='contained'
        to={props.links.eventNew}
        color='primary'
        size='large'
        component={WrappedNavLink}
        startIcon={<AddIcon />}
      >
        <FormattedMessage {...messages.new} />
      </Button>
      <Box className={classes.floatSpacer} />
      <Paper>
        <ResponsiveTabs
          value={props.currentTab}
          onChange={props.handleChangeTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab label={intl.formatMessage(messages.index.upcoming)} />
          <Tab label={intl.formatMessage(messages.index.ongoing)} />
          <Tab label={intl.formatMessage(messages.index.past)} />
        </ResponsiveTabs>
      </Paper>
      <br />
      <DiverstLoader isLoading={props.isLoading}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */}
          {props.events && Object.values(props.events).map((item, i) => {
            return (
              <Grid item key={item.id} className={classes.eventListItem}>
                {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                <Link
                  className={classes.eventLink}
                  component={WrappedNavLink}
                  to={{
                    pathname: ROUTES.group.events.show.path(item.owner_group_id, item.id),
                    state: { id: item.id }
                  }}
                >
                  <Card>
                    <CardContent>
                      <Grid container spacing={1} justify='space-between' alignItems='center'>
                        <Grid item xs>
                          <Typography color='primary' variant='h6' component='h2'>
                            {item.name}
                          </Typography>
                          <hr className={classes.divider} />
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
                    </CardContent>
                  </Card>
                </Link>
              </Grid>
            );
          })}
          {props.events && props.events.length <= 0 && (
            <React.Fragment>
              <Grid item sm>
                <Box mt={3} />
                <Typography variant='h6' align='center' color='textSecondary'>
                  <FormattedMessage {...messages.index.emptySection} />
                </Typography>
              </Grid>
            </React.Fragment>
          )}
        </Grid>
      </DiverstLoader>
      {props.events && props.events.length > 0 && (
        <DiverstPagination
          isLoading={props.isLoading}
          count={props.eventsTotal}
          handlePagination={props.handlePagination}
        />
      )}
    </React.Fragment>
  );
}

EventsList.propTypes = {
  intl: PropTypes.object,
  classes: PropTypes.object,
  events: PropTypes.array,
  eventsTotal: PropTypes.number,
  currentTab: PropTypes.number,
  isLoading: PropTypes.bool,
  handleChangeTab: PropTypes.func,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
};

export default compose(
  injectIntl,
  withStyles(styles),
  memo,
)(EventsList);
