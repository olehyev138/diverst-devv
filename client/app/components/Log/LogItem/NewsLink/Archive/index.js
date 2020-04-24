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
export function NewsLinkArchive(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <React.Fragment>
      <LogOwner activity={activity} />
      {' archived a news item '}
      { activity.trackable ? (
        <React.Fragment>
          <Link
            component={WrappedNavLink}
            to={ROUTES.admin.manage.archived.path()}
          >
            {activity.trackable.title}
          </Link>
        </React.Fragment>
      ) : (
        <React.Fragment>
          {' which has since been removed '}
        </React.Fragment>
      )}
      {' at '}
      { formatDateTimeString(activity.created_at, DateTime.DATETIME_FULL) }
    </React.Fragment>
  );
}

NewsLinkArchive.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(NewsLinkArchive);
