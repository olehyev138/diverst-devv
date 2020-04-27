import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import LogOwner from 'components/Log/LogItem/Shared/Owner';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import { DateTime } from 'luxon';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { Link, Avatar, Box } from '@material-ui/core';
import DiverstImg from 'components/Shared/DiverstImg';

// This component for displaying log owner
export function UserAcceptPending(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <Box display='flex' alignItems='center' width='auto'>
      <Box order={1} mr={1}>
        <LogOwner activity={activity} />
      </Box>
      <Box order={2}>
        { activity.trackable ? (
          <React.Fragment>
            <Link
              component={WrappedNavLink}
              to={ROUTES.group.home.path(activity.parameters.group.id)}
            >
              {activity.parameters.group.name}
            </Link>
            {' at '}
            { formatDateTimeString(activity.created_at, DateTime.DATETIME_FULL) }
          </React.Fragment>
        ) : (
          <React.Fragment>
            {' at '}
            { formatDateTimeString(activity.created_at, DateTime.DATETIME_FULL) }
          </React.Fragment>
        )}
      </Box>
    </Box>
  );
}

UserAcceptPending.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(UserAcceptPending);
