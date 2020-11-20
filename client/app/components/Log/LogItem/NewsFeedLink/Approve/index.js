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
export function NewsFeedLinkApprove(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <Box display='flex' alignItems='center' width='auto'>
      <Box order={1} mr={1}>
        <LogOwner activity={activity} />
      </Box>
      <Box order={2}>
        {' approved a '}
        { activity.trackable ? (
          <React.Fragment>
            { activity.trackable.group_message ? (
              <React.Fragment>
                <Link
                  component={WrappedNavLink}
                  to={ROUTES.group.news.messages.show.path(activity.trackable.group_id, activity.trackable_id)}
                >
                  {'group message'}
                </Link>
              </React.Fragment>
            ) : activity.trackable.news_link ? (
              <React.Fragment>
                <Link
                  component={WrappedNavLink}
                  to={ROUTES.group.news.news_links.show.path(activity.trackable.group_id, activity.trackable_id)}
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
                  to={ROUTES.group.home.path(activity.trackable_id)}
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
      </Box>
    </Box>
  );
}

NewsFeedLinkApprove.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(NewsFeedLinkApprove);