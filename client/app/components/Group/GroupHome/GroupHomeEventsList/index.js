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
  Box, CardContent, Grid, Link, Typography, Divider, CardActionArea
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
      <DiverstLoader isLoading={props.isLoading} {...props.loaderProps}>
        <Grid container spacing={3}>
          { /* eslint-disable-next-line arrow-body-style */}
          {props.events && Object.values(props.events).map((item, i) => {
            return (
              <Grid item key={item.id} className={classes.eventListItem}>
                <Box mb={1} />
                <Divider />
                <Box mb={1} />
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
  onlyUpcoming: PropTypes.bool,
  loaderProps: PropTypes.object,
};

export default compose(
  injectIntl,
  withStyles(styles),
  memo,
)(EventsList);
