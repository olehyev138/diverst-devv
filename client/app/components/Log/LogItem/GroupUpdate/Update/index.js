import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import LogOwner from 'components/Log/LogItem/Shared/Owner';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import { DateTime } from 'luxon';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { Link, Avatar } from '@material-ui/core';
import DiverstImg from 'components/Shared/DiverstImg';

// This component for displaying log owner
export function GroupUpdateUpdate(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <React.Fragment>
      <LogOwner activity={activity} />
      {' updated '}
      { activity.trackable ? (
        <React.Fragment>
          <Link
            component={WrappedNavLink}
            to={ROUTES.group.manage.updates.show.path(activity.trackable.group.id, activity.trackable_id)}
          >
            {`group update for ${activity.trackable.group.name}`}
          </Link>
        </React.Fragment>
      ) : (
        <React.Fragment>
          {' group update which has since been removed '}
        </React.Fragment>
      )}
      {' at '}
      { formatDateTimeString(activity.created_at, DateTime.DATETIME_FULL) }
    </React.Fragment>
  );
}

GroupUpdateUpdate.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(GroupUpdateUpdate);
