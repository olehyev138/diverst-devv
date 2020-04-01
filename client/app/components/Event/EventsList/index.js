/**
 *
 * Events List Component
 *
 */

import React, { memo, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { RouteContext } from 'containers/Layouts/ApplicationLayout';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Tab, Paper, Card, CardContent, Grid, Link, Typography, Button, CardActionArea
} from '@material-ui/core';

import AddIcon from '@material-ui/icons/Add';

import { injectIntl } from 'react-intl';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import DiverstPagination from 'components/Shared/DiverstPagination';

import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Event/messages';
import { customTexts } from 'utils/customTextHelpers';

import EventListItem from 'components/Event/EventListItem';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';

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
    textDecoration: 'none !important',
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
      {!props.readonly && (
        <React.Fragment>
          <Permission show={permission(props.currentGroup, 'events_create?')}>
            <Button
              className={classes.floatRight}
              variant='contained'
              to={props.links.eventNew}
              color='primary'
              size='large'
              component={WrappedNavLink}
              startIcon={<AddIcon />}
            >
              <DiverstFormattedMessage {...messages.new} />
            </Button>
          </Permission>
          <Box className={classes.floatSpacer} />
        </React.Fragment>
      )}
      <Paper>
        {props.currentPTab != null && (
          <ResponsiveTabs
            value={props.currentPTab}
            onChange={props.handleChangePTab}
            indicatorColor='primary'
            textColor='primary'
          >
            <Tab label={intl.formatMessage(messages.index.participating)} />
            <Tab label={intl.formatMessage(messages.index.all)} />
          </ResponsiveTabs>
        )}
        <ResponsiveTabs
          value={props.currentTab}
          onChange={props.handleChangeTab}
          indicatorColor='primary'
          textColor='primary'
        >
          <Tab label={intl.formatMessage(messages.index.upcoming, customTexts())} />
          <Tab label={intl.formatMessage(messages.index.ongoing, customTexts())} />
          <Tab label={intl.formatMessage(messages.index.past, customTexts())} />
        </ResponsiveTabs>
      </Paper>
      <br />
      <DiverstLoader isLoading={props.isLoading} {...props.loaderProps}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */}
          {props.events && Object.values(props.events).map((item, i) => {
            return (
              <Grid item key={item.id} className={classes.eventListItem}>
                <Card>
                  {/* eslint-disable-next-line jsx-a11y/anchor-is-valid */}
                  <Link
                    className={classes.eventLink}
                    component={WrappedNavLink}
                    to={{
                      pathname: ROUTES.group.events.show.path(item.owner_group_id, item.id),
                      state: { id: item.id }
                    }}
                  >
                    <CardActionArea>
                      <CardContent>
                        <EventListItem item={item} />
                      </CardContent>
                    </CardActionArea>
                  </Link>
                </Card>
              </Grid>
            );
          })}
          {props.events && props.events.length <= 0 && (
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
  currentPTab: PropTypes.number,
  handleChangePTab: PropTypes.func,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
  readonly: PropTypes.bool,
  loaderProps: PropTypes.object,
  currentGroup: PropTypes.object,
};

export default compose(
  injectIntl,
  withStyles(styles),
  memo,
)(EventsList);
