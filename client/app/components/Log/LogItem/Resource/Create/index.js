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
import { getFolderShowPath } from 'utils/resourceHelpers';

// This component for displaying log owner
export function ResourceCreate(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <Box display='flex' alignItems='center' width='auto'>
      <Box order={1} mr={1}>
        <LogOwner activity={activity} />
      </Box>
      <Box order={2}>
        {' created '}
        { activity.trackable ? (
          <React.Fragment>
            { activity.trackable.initiative_id ? (
              <React.Fragment>
                {' event resource '}
                <Link
                  component={WrappedNavLink}
                  to={getFolderShowPath(activity.trackable)}
                >
                  {activity.trackable.title}
                </Link>
              </React.Fragment>
            ) : activity.trackable.enterprise_id ? (
              <React.Fragment>
                {' enterprise resource '}
                <Link
                  component={WrappedNavLink}
                  to={getFolderShowPath(activity.trackable)}
                >
                  {activity.trackable.title}
                </Link>
              </React.Fragment>
            ) : activity.trackable.group_id ? (
              <React.Fragment>
                {' group resource '}
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
            {' a resource which has since been removed '}
          </React.Fragment>
        )}
        {' at '}
        { formatDateTimeString(activity.created_at, DateTime.DATETIME_FULL) }
      </Box>
    </Box>
  );
}

ResourceCreate.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(ResourceCreate);
