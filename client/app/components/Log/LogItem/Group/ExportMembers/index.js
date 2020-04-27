import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import LogOwner from 'components/Log/LogItem/Shared/Owner';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import { DateTime } from 'luxon';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { Link, Box } from '@material-ui/core';

// This component for displaying log owner
export function UserLogin(props) {
  const { activity, ...rest } = props;

  return (
    <Box display='flex' alignItems='center' width='auto'>
      <Box order={1} mr={1}>
        <LogOwner activity={activity} />
      </Box>
      <Box order={2}>
        {' exported members via CSV of group '}
        { activity.trackable ? (
          <Link
            component={WrappedNavLink}
            to={ROUTES.group.home.path(activity.trackable_id)}
          >
            {activity.trackable.name}
          </Link>
        ) : ' Which has been removed '}
        {' at '}
        { formatDateTimeString(activity.created_at, DateTime.DATETIME_FULL) }
      </Box>
    </Box>
  );
}

UserLogin.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(UserLogin);
