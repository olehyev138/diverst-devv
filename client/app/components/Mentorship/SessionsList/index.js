/**
 *
 * Session List Component
 *
 */

import React, { memo, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Tab, Paper, Card, CardContent, Grid, Link, Typography, Button, Hidden, CardHeader,
} from '@material-ui/core';

import KeyboardArrowRightIcon from '@material-ui/icons/KeyboardArrowRight';
import AddIcon from '@material-ui/icons/Add';

import { injectIntl } from 'react-intl';
import messages from 'containers/Mentorship/Session/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import DiverstPagination from 'components/Shared/DiverstPagination';

import { formatDateTimeString, DateTime } from 'utils/dateTimeHelpers';
import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import { customTexts } from 'utils/customTextHelpers';

const styles = theme => ({
  sessionListItem: {
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
  sessionLink: {
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

export function SessionsList(props, context) {
  const { classes, intl } = props;

  const routeContext = useContext(RouteContext);
  const titleMessage = props.type === 'hosting' ? messages.title.hosting : messages.title.participating;

  return (
    <React.Fragment>
      <Card>
        <CardHeader
          title={(
            <Typography variant='h5' align='center' color='primary'>
              <DiverstFormattedMessage {...titleMessage} />
            </Typography>
          )}
        />
        <ResponsiveTabs
          value={props.currentTab}
          onChange={props.handleChangeTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab label={intl.formatMessage(messages.index.past, customTexts())} />
          <Tab label={intl.formatMessage(messages.index.ongoing, customTexts())} />
          <Tab label={intl.formatMessage(messages.index.upcoming, customTexts())} />
        </ResponsiveTabs>
      </Card>
      <br />
      <DiverstLoader isLoading={props.isLoading} {...props.loaderProps}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */}
          {props.sessions && Object.values(props.sessions).map((item, i) => {
            return (
              <Grid item key={item.id} className={classes.sessionListItem}>
                {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                <Link
                  className={classes.sessionLink}
                  component={WrappedNavLink}
                  to={{
                    pathname: props.links.sessionShow(item.id),
                    state: { id: item.id }
                  }}
                >
                  <Card>
                    <CardContent>
                      <Grid container spacing={1} justify='space-between' alignItems='center'>
                        <Grid item xs>
                          <Typography color='primary' variant='h6' component='h2'>
                            {item.interests || 'Mentorship'}
                          </Typography>
                          <hr className={classes.divider} />
                          {item.interests && (
                            <React.Fragment>
                              <Typography color='textSecondary'>
                                {`Hosted by ${item.creator.name}`}
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
          {props.sessions && props.sessions.length <= 0 && (
            <React.Fragment>
              <Grid item sm>
                <Box mt={3} />
                <Typography variant='h6' align='center' color='textSecondary'>
                  <DiverstFormattedMessage {...messages.index.emptySection} />
                </Typography>
              </Grid>
            </React.Fragment>
          )}
        </Grid>
      </DiverstLoader>
      {props.sessions && props.sessions.length > 0 && (
        <DiverstPagination
          isLoading={props.isLoading}
          count={props.sessionsTotal}
          handlePagination={props.handlePagination}
        />
      )}
    </React.Fragment>
  );
}

SessionsList.propTypes = {
  type: PropTypes.string.isRequired,
  intl: PropTypes.object,
  classes: PropTypes.object,
  sessions: PropTypes.array,
  sessionsTotal: PropTypes.number,
  currentTab: PropTypes.number,
  isLoading: PropTypes.bool,
  handleChangeTab: PropTypes.func,
  currentPTab: PropTypes.number,
  handleChangePTab: PropTypes.func,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
  readonly: PropTypes.bool,
  loaderProps: PropTypes.object,
};

export default compose(
  injectIntl,
  withStyles(styles),
  memo,
)(SessionsList);
