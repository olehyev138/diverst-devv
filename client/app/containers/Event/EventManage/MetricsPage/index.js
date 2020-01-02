import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { selectUser } from 'containers/Shared/App/selectors';

import {
  getEventBegin, eventsUnmount, deleteEventBegin
} from 'containers/Event/actions';

import Metrics from 'components/Event/EventManage/Metrics';
import EventManageLayout from 'containers/Layouts/EventManageLayout';

export function MetricsPage(props) {
  const { currentUser } = props;

  return (
    <EventManageLayout
      component={() => (
        <Metrics
          currentUserId={currentUser.id}
          deleteEventBegin={props.deleteEventBegin}
          isFormLoading={props.isFormLoading}
        />
      )}
      {...props}
    />
  );
}

MetricsPage.propTypes = {
  getEventBegin: PropTypes.func,
  deleteEventBegin: PropTypes.func,
  eventsUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEvent: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
});

const mapDispatchToProps = {
  getEventBegin,
  deleteEventBegin,
  eventsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(MetricsPage);
