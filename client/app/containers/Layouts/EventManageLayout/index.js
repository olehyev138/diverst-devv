import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';

import { withStyles } from '@material-ui/core/styles';
import Fade from '@material-ui/core/Fade';

import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Event/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Event/saga';

import RouteService from 'utils/routeHelpers';
import { createStructuredSelector } from 'reselect';

import {selectEvent, selectIsFormLoading} from 'containers/Event/selectors';
import { eventsUnmount, getEventBegin } from 'containers/Event/actions';

import EventManageLinks from 'components/Event/EventManage/EventManageLinks';
import Box from '@material-ui/core/Box';
import GroupLayout from '../GroupLayout';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const EventManagePages = Object.freeze([
  'metrics', // NOT IMPLEMENTED
  'fields',
  'updates',
  'resources',
  'expenses',
]);

const EventManageLayout = ({ component: Component, ...rest }) => {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  const { computedMatch, location, data, classes, ...other } = rest;

  const rs = new RouteService({ computedMatch, location });

  /* Get last element of current path, ie: '/group/:id/plan/outcomes -> outcomes */
  const currentPage = EventManagePages.find(page => location.pathname.includes(page));
  const [tab, setTab] = useState(currentPage);

  useEffect(() => {
    if (tab !== currentPage)
      setTab(currentPage);
  }, [currentPage]);

  useEffect(() => {
    const eventId = rs.params('event_id');
    rest.getEventBegin({ id: eventId });

    return () => {
      rest.eventsUnmount();
    };
  }, []);

  return (
    <GroupLayout
      {...rest}
      component={matchProps => (
        other.event && (
          <React.Fragment>
            <EventManageLinks
              currentTab={tab}
              {...matchProps}
            />
            <Box mb={3} />
            <Fade in appear>
              <div>
                <Component {...other} />
              </div>
            </Fade>
          </React.Fragment>
        )
      )}
    />
  );
};

EventManageLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  event: PropTypes.object,
  getEventBegin: PropTypes.func,
  eventsUnmount: PropTypes.func,
  isLoading: PropTypes.bool,
  computedMatch: PropTypes.object,
  location: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  event: selectEvent(),
  isLoading: selectIsFormLoading(),
});

const mapDispatchToProps = {
  getEventBegin,
  eventsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
  withStyles(styles),
)(Conditional(
  EventManageLayout,
  ['event.permissions.update?', 'isLoading'],
  (props, rs) => ROUTES.group.events.show.path(rs.params('group_id'), rs.params('event_id')),
  'You don\'t have permission manage this event'
));
