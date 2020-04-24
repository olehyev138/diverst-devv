import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import LogOwner from 'components/Log/LogItem/LogOwner';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import { DateTime } from 'luxon';

// This component for displaying log owner
export function UserLogin(props) {
  const { rowData, ...rest } = props;

  return (
    <React.Fragment>
      <LogOwner rowData={rowData} />
      {' Logged in '}
      { rowData.parameters.ip && `with IP: ${rowData.parameters.ip}`}
      {' at '}
      { formatDateTimeString(rowData.created_at, DateTime.DATETIME_FULL) }
    </React.Fragment>
  );
}

UserLogin.propTypes = {
  rowData: PropTypes.object,
};

export default compose(
  memo,
)(UserLogin);
