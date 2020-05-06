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
export function NewsLinkCreate(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <Box display='flex' alignItems='center' width='auto'>
      <Box order={1} mr={1}>
        <LogOwner activity={activity} />
      </Box>
      <Box order={2}>
        {' created a news item '}
        { activity.trackable ? (
          <React.Fragment>
            <Link
              component={WrappedNavLink}
              to={ROUTES.group.news.news_links.show.path(activity.trackable.group_id, activity.trackable.news_feed_link.id)}
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
      </Box>
    </Box>
  );
}

NewsLinkCreate.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(NewsLinkCreate);
