import React, { memo, useEffect, useState } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { useLocation, useParams } from 'react-router-dom';

import { Fade, Box } from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Event/reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from 'containers/Event/saga';

import { createStructuredSelector } from 'reselect';

import { selectEvent, selectIsFormLoading } from 'containers/Event/selectors';
import { eventsUnmount, getEventBegin } from 'containers/Event/actions';

import EventManageLinks from 'components/Event/EventManage/EventManageLinks';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import permissionMessages from 'containers/Shared/Permissions/messages';

import { renderChildrenWithProps } from 'utils/componentHelpers';

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

const EventManageLayout = (props) => {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  const { classes, children, ...rest } = props;

  const location = useLocation();
  const { event_id: eventId } = useParams();

  /* Get last element of current path, ie: '/group/:id/plan/outcomes -> outcomes */
  const currentPage = EventManagePages.find(page => location.pathname.includes(page));
  const [tab, setTab] = useState(currentPage);

  useEffect(() => {
    if (tab !== currentPage)
      setTab(currentPage);
  }, [currentPage]);

  useEffect(() => {
    rest.getEventBegin({ id: eventId });

    return () => {
      rest.eventsUnmount();
    };
  }, []);

  return (
    rest.event && (
      <React.Fragment>
        <EventManageLinks
          currentTab={tab}
          event={props.event}
        />
        <Box mb={3} />
        <Fade in appear>
          <div>
            {renderChildrenWithProps(children, { ...rest })}
          </div>
        </Fade>
      </React.Fragment>
    )
  );
};

EventManageLayout.propTypes = {
  classes: PropTypes.object,
  children: PropTypes.any,
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
  (props, params) => ROUTES.group.events.show.path(params.group_id, params.event_id),
  permissionMessages.layouts.eventManage
));
