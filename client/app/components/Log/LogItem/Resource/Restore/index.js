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
import { getFolderShowPath } from 'utils/resourceHelpers';

// This component for displaying log owner
export function ResourceRestore(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <React.Fragment>
      <LogOwner activity={activity} />
      { activity.trackable ? (
        <React.Fragment>
          { activity.trackable.group_id ? (
            <React.Fragment>
              {' restored a group resource '}
              <Link
                component={WrappedNavLink}
                to={getFolderShowPath(activity.trackable)}
              >
                {activity.trackable.title}
              </Link>
            </React.Fragment>
          ) : activity.trackable.enterprise_id ? (
            <React.Fragment>
              {' restored an enterprise resource '}
              <Link
                component={WrappedNavLink}
                to={getFolderShowPath(activity.trackable)}
              >
                {activity.trackable.title}
              </Link>
            </React.Fragment>
          ) : <React.Fragment />}
        </React.Fragment>
      ) : (
        <React.Fragment>
          {' restored a resource which has since been removed '}
        </React.Fragment>
      )}
      {' at '}
      { formatDateTimeString(activity.created_at, DateTime.DATETIME_FULL) }
    </React.Fragment>
  );
}

ResourceRestore.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(ResourceRestore);
