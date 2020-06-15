// mock store for EventManageLayout
import React from 'react';
import EventManageLayout from '../index';
import PropTypes from 'prop-types';

function MockEventManageLayout(props) {
  return (
    <div>
      <EventManageLayout {...props} />
    </div>
  );
}

MockEventManageLayout.propTypes = {
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

export default MockEventManageLayout;
