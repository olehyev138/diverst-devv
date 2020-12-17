/**
 *
 * Events List Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Card, CardContent, Grid, Link, Typography,
} from '@material-ui/core';

import messages from 'containers/GlobalSettings/Email/Event/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import DiverstPagination from 'components/Shared/DiverstPagination';

import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

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

export function EventsList(props) {
  const { classes } = props;

  return (
    <React.Fragment>
      <DiverstLoader isLoading={props.isLoading} {...props.loaderProps}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */}
          {props.events && props.events.map((item, i) => {
            return (
              <Grid item key={item.id} className={classes.eventListItem}>
                {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                <Link
                  className={classes.eventLink}
                  component={WrappedNavLink}
                  to={{
                    pathname: props.links.eventEdit(item.id),
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
                          <Box pt={1} />
                          <Grid container spacing={1} justify='space-between' alignItems='center'>
                            <Grid item md={4} sm={12}>
                              <Typography color='textSecondary' variant='subtitle2' className={classes.dateText}>
                                {item.day.label}
                              </Typography>
                            </Grid>
                            <Grid item md={4} sm={12}>
                              <Typography color='textSecondary' variant='subtitle2' className={classes.dateText}>
                                {item.at12}
                              </Typography>
                            </Grid>
                            <Grid item md={4} sm={12}>
                              <Typography color='textSecondary' variant='subtitle2' className={classes.dateText}>
                                {item.tz.label}
                              </Typography>
                            </Grid>
                          </Grid>
                        </Grid>
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
                  <DiverstFormattedMessage {...messages.index.empty} />
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
  classes: PropTypes.object,
  events: PropTypes.array,
  eventsTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
  loaderProps: PropTypes.object,
};

export default compose(
  withStyles(styles),
  memo,
)(EventsList);
