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
export function NewsFeedLinkApprove(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <React.Fragment>
      <LogOwner activity={activity} />
      {' approved a '}
      { activity.trackable ? (
        <React.Fragment>
          { activity.trackable.group_message ? (
            <React.Fragment>
              <Link
                component={WrappedNavLink}
                to={ROUTES.user.home.path()}
              >
                {'group message'}
              </Link>
            </React.Fragment>
          ) : activity.trackable.news_link ? (
            <React.Fragment>
              <Link
                component={WrappedNavLink}
                to={ROUTES.user.home.path()}
              >
                {'news link'}
              </Link>
            </React.Fragment>
          ) : activity.trackable.social_link ? (
            <React.Fragment>
              {` social link ${activity.trackable.social_link.url} `}
            </React.Fragment>
          ) : <React.Fragment />}
          { activity.trackable.group ? (
            <React.Fragment>
              {' for group '}
              <Link
                component={WrappedNavLink}
                to={ROUTES.user.home.path()}
              >
                {activity.trackable.group.name}
              </Link>
            </React.Fragment>
          ) : <React.Fragment />}
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

NewsFeedLinkApprove.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(NewsFeedLinkApprove);
