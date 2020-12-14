/**
 *
 * Events List Component
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Box, Tab, Paper, Card, CardContent, Grid, Link, Typography, Button, CardActionArea, IconButton, Tooltip
} from '@material-ui/core';

import AddIcon from '@material-ui/icons/Add';
import TodayIcon from '@material-ui/icons/Today';
import ListAltIcon from '@material-ui/icons/ListAlt';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

import ResponsiveTabs from 'components/Shared/ResponsiveTabs';
import DiverstPagination from 'components/Shared/DiverstPagination';

import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Event/messages';

import EventListItem from 'components/Event/EventListItem';
import Permission from 'components/Shared/DiverstPermission';
import { permission } from 'utils/permissionsHelpers';
import DiverstCalendar from 'components/Shared/DiverstCalendar';
import Dialog from '@material-ui/core/Dialog';
import DialogContent from '@material-ui/core/DialogContent';
import EventLite from 'components/Event/EventLite';
import { toNumber } from 'utils/floatRound';
import { createStructuredSelector } from 'reselect';
import { joinEventBegin, leaveEventBegin } from 'containers/Event/actions';
import { connect } from 'react-redux';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Event/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Event/saga';
import { selectIsCommitting } from 'containers/Event/selectors';
import { selectCustomText } from 'containers/Shared/App/selectors';
import { injectIntl, intlShape } from 'react-intl';

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
  buttons: {
    marginLeft: 10,
    marginRight: 10,
    float: 'right',
  },
});

export function EventsList(props) {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });
  const { classes, intl } = props;

  const [eventId, setEvent] = useState(null);

  const clickEvent = (info) => {
    const { event } = info;
    // const extra = event.extendedProps;
    setEvent(toNumber(event.id));
  };

  const dialog = (
    <Dialog
      open={!!eventId}
      onClose={() => setEvent(null)}
    >
      <DialogContent>
        <EventLite
          event={props.events.find(event => event.id === eventId)}
          isCommiting={props.isCommitting}
          joinEventBegin={props.joinEventBegin}
          leaveEventBegin={props.leaveEventBegin}
        />
      </DialogContent>
    </Dialog>
  );

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
        <React.Fragment>
          <Grid container justify='center'>
            <Grid item xs={1} />
            {props.currentPTab != null && (
              <Grid item xs={10}>
                <ResponsiveTabs
                  value={props.currentPTab}
                  onChange={props.handleChangePTab}
                  indicatorColor='primary'
                  textColor='primary'
                >
                  <Tab label={<DiverstFormattedMessage {...messages.index.participating} />} />
                  <Tab label={<DiverstFormattedMessage {...messages.index.all} />} />
                </ResponsiveTabs>
              </Grid>
            )}
            <Grid item xs>
              <Tooltip
                title={<DiverstFormattedMessage {...messages[props.calendar ? 'list' : 'calendar']} />}
                placement='top'
              >
                <IconButton
                  onClick={props.handleCalendarChange}
                  className={classes.buttons}
                >
                  {props.calendar ? <ListAltIcon /> : <TodayIcon />}
                </IconButton>
              </Tooltip>
            </Grid>
          </Grid>
          {props.onlyUpcoming || props.calendar || (
            <ResponsiveTabs
              value={props.currentTab}
              onChange={props.handleChangeTab}
              indicatorColor='primary'
              textColor='primary'
            >
              <Tab label={<DiverstFormattedMessage {...messages.index.upcoming} />} />
              <Tab label={<DiverstFormattedMessage {...messages.index.ongoing} />} />
              <Tab label={<DiverstFormattedMessage {...messages.index.past} />} />
            </ResponsiveTabs>
          )}
        </React.Fragment>
      </Paper>
      <br />
      { props.calendar ? (
        <DiverstCalendar
          calendarEvents={props.calendarEvents}
          isLoading={props.isLoading}
          events={props.calendarEvents}
          joinEventBegin={props.joinEventBegin}
          leaveEventBegin={props.leaveEventBegin}
          calendarDateCallback={props.calendarDateCallback}
        />
      ) : (
        <React.Fragment>
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
                          pathname: ROUTES.group.events.show.path(
                            (() => {
                              if (props.currentGroup)
                                return props.currentGroup.id;
                              if (item.group.current_user_is_member)
                                return item.group.id;
                              let usersGroup;
                              // eslint-disable-next-line no-cond-assign
                              if ((usersGroup = item.participating_groups.find(g => g.current_user_is_member)))
                                return usersGroup.id;
                              // eslint-disable-next-line no-console
                              console.error('Not in any participating groups');
                              return item.group.id;
                            })(),
                            item.id
                          ),
                          state: { id: item.id }
                        }}
                      >
                        <CardActionArea>
                          <CardContent>
                            <EventListItem item={item} currentGroupID={props.currentGroup ? props.currentGroup.id : null} />
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
              page={props.params.page}
              rowsPerPage={props.params.count}
              handlePagination={props.handlePagination}
              customTexts={props.customTexts}
            />
          )}
        </React.Fragment>
      )}
    </React.Fragment>
  );
}

EventsList.propTypes = {
  classes: PropTypes.object,
  events: PropTypes.array,
  calendarEvents: PropTypes.array,
  eventsTotal: PropTypes.number,
  currentTab: PropTypes.number,
  calendar: PropTypes.bool,
  handleCalendarChange: PropTypes.func,
  isLoading: PropTypes.bool,
  isCommitting: PropTypes.bool,
  handleChangeTab: PropTypes.func,
  currentPTab: PropTypes.number,
  handleChangePTab: PropTypes.func,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
  readonly: PropTypes.bool,
  onlyUpcoming: PropTypes.bool,
  loaderProps: PropTypes.object,
  currentGroup: PropTypes.object,
  joinEventBegin: PropTypes.func,
  leaveEventBegin: PropTypes.func,
  calendarDateCallback: PropTypes.func,
  currentGroupID: PropTypes.number,
  params: PropTypes.shape({
    page: PropTypes.number,
    count: PropTypes.number
  }),
  intl: intlShape.isRequired,
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectIsCommitting(),
  customTexts: selectCustomText()
});

const mapDispatchToProps = {
  joinEventBegin,
  leaveEventBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  injectIntl,
  withStyles(styles),
  memo,
)(EventsList);
