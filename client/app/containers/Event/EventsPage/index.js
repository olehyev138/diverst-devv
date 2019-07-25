import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import dig from 'object-dig';
import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Event/reducer';
import saga from 'containers/Event/saga';

import { selectPaginatedEvents, selectEventsTotal } from 'containers/Event/selectors';
import { getEventsBegin, eventsUnmount } from 'containers/Event/actions';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import EventsList from 'components/Event/EventsList';

export function EventsPage(props) {
  useInjectReducer({ key: 'events', reducer });
  useInjectSaga({ key: 'events', saga });

  const [params, setParams] = useState({
    count: 10, // TODO: Make this a constant and use it also in EventsList
    page: 0,
    order: 'desc',
    orderBy: 'start',
    group_id: -1
  });

  const rs = new RouteService(useContext);
  const links = {
    eventsIndex: ROUTES.group.events.index.path(rs.params('group_id')),
  };

  useEffect(() => {
    const id = dig(props, 'currentGroup', 'id');

    if (id) {
      const newParams = { ...params, group_id: id };
      props.getEventsBegin(newParams);
      setParams(newParams);
    }

    return () => {
      props.eventsUnmount();
    };
  }, [props.currentGroup]);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getEventsBegin(newParams);
    setParams(newParams);
  };

  return (
    <EventsList
      events={props.events}
      eventsTotal={props.eventsTotal}
      handlePagination={handlePagination}
      links={links}
    />
  );
}

EventsPage.propTypes = {
  getEventsBegin: PropTypes.func.isRequired,
  eventsUnmount: PropTypes.func.isRequired,
  events: PropTypes.array,
  eventsTotal: PropTypes.number,
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
  }),
};

const mapStateToProps = createStructuredSelector({
  events: selectPaginatedEvents(),
  eventsTotal: selectEventsTotal(),
});

const mapDispatchToProps = {
  getEventsBegin,
  eventsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(EventsPage);
