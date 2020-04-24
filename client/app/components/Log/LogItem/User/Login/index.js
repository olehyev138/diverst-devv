import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import LogOwner from 'components/Log/LogItem/LogOwner';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import { DateTime } from 'luxon';

// This component for displaying log owner
export function UserLogin(props) {
  const { activity, ...rest } = props;

  return (
    <React.Fragment>
      <LogOwner activity={activity} />
      {' Logged in '}
      { activity.parameters.ip && `with IP: ${activity.parameters.ip}`}
      {' at '}
      { formatDateTimeString(activity.created_at, DateTime.DATETIME_FULL) }
    </React.Fragment>
  );
}

UserLogin.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(UserLogin);
