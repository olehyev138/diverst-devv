import React, { memo, useContext, useEffect, useState } from 'react';
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

import { selectEvent } from 'containers/Event/selectors';
import { getEventBegin, eventsUnmount } from 'containers/Event/actions';

import EventManageLinks from 'components/Event/EventManage/EventManageLinks';

const styles = theme => ({
  content: {
    padding: theme.spacing(3),
  },
});

const EventManagePages = Object.freeze({
  metrics: 0,
  resources: 1,
  expenses: 2,
});

const getPageTab = (currentPagePath) => {
  if (EventManagePages[currentPagePath] !== undefined)
    return EventManagePages[currentPagePath];

  return false;
};

const EventManageLayout = ({ component: Component, classes, ...props }) => {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  const rs = new RouteService(useContext);

  const { computedMatch, location, event, ...rest } = props;

  /* Get last element of current path, ie: '/group/:id/plan/outcomes -> outcomes */
  const currentPagePath = location.pathname.split('/').pop();
  const [tab, setTab] = useState(getPageTab(currentPagePath));

  useEffect(() => {
    if (tab !== getPageTab(currentPagePath))
      setTab(getPageTab(currentPagePath));
  }, [currentPagePath]);

  useEffect(() => {
    const eventId = rs.params('event_id');
    props.getEventBegin({ id: eventId });

    return () => {
      props.eventsUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      {event && (
        <React.Fragment>
          <EventManageLinks
            currentTab={tab}
            event={event}
            {...rest}
          />
          <Fade in appear>
            <div className={classes.content}>
              <Component {...rest} event={event} />
            </div>
          </Fade>
        </React.Fragment>
      )}
    </React.Fragment>
  );
};

EventManageLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  event: PropTypes.object,
  getEventBegin: PropTypes.func,
  eventsUnmount: PropTypes.func,
  computedMatch: PropTypes.object,
  location: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  event: selectEvent(),
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
)(EventManageLayout);
