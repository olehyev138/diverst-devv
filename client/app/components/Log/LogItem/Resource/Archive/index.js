import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import LogOwner from 'components/Log/LogItem/LogOwner';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import { DateTime } from 'luxon';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { Link, Avatar } from '@material-ui/core';
import DiverstImg from 'components/Shared/DiverstImg';

// This component for displaying log owner
export function ResourceArchive(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <React.Fragment>
      <LogOwner rowData={activity} />
      { activity.trackable ? (
        <React.Fragment>
          { activity.trackable.container.group ? (
            <React.Fragment>
              {' archived a group resource '}
              <Link
                component={WrappedNavLink}
                to={ROUTES.home.path()}
              >
                {activity.trackable.title}
              </Link>
            </React.Fragment>
          ) : activity.trackable.container.enterprise ? (
            <React.Fragment>
              {' archived an enterprise resource '}
              <Link
                component={WrappedNavLink}
                to={ROUTES.home.path()}
              >
                {activity.trackable.title}
              </Link>
            </React.Fragment>
          ) : <React.Fragment />}
        </React.Fragment>
      ) : (
        <React.Fragment>
          {' archived a resource which has since been removed '}
        </React.Fragment>
      )}
      {' at '}
      { formatDateTimeString(activity.created_at, DateTime.DATETIME_FULL) }
    </React.Fragment>
  );
}

ResourceArchive.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(ResourceArchive);
