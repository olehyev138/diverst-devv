import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import LogOwner from 'components/Log/LogItem/LogOwner';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import { DateTime } from 'luxon';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { Link } from '@material-ui/core';

// This component for displaying log owner
export function UserLogin(props) {
  const { rowData, ...rest } = props;

  return (
    <React.Fragment>
      <LogOwner rowData={rowData} />
      {' exported members via CSV of group '}
      { rowData.trackable ? (
        <Link
          component={WrappedNavLink}
          to={ROUTES.group.home.path(rowData.trackable_id)}
        >
          {rowData.trackable.name}
        </Link>
      ) : ' Which has been removed '}
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
