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
import { getFolderShowPath } from 'utils/resourceHelpers';

// This component for displaying log owner
export function ViewTrack(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <React.Fragment>
      <LogOwner activity={activity} />
      { activity.trackable ? (
        <React.Fragment>
          { activity.trackable.resource ? (
            <React.Fragment>
              { activity.trackable.resource.group_id ? (
                <React.Fragment>
                  <Link
                    component={WrappedNavLink}
                    to={getFolderShowPath(activity.trackable)}
                  >
                    {activity.trackable.resource.title}
                  </Link>
                </React.Fragment>
              ) : activity.trackable.resource.enterprise_id ? (
                <React.Fragment>
                  <Link
                    component={WrappedNavLink}
                    to={getFolderShowPath(activity.trackable)}
                  >
                    {activity.trackable.resource.title}
                  </Link>
                </React.Fragment>
              ) : <React.Fragment />}
              {'  '}
            </React.Fragment>
          ) : activity.trackable.group ? (
            <React.Fragment>
              <Link
                component={WrappedNavLink}
                to={ROUTES.group.home.path(activity.trackable_id)}
              >
                {activity.trackable.group.name}
              </Link>
              {'  '}
            </React.Fragment>
          ) : activity.trackable.folder ? (
            <React.Fragment>
              {' viewed a  '}
              { activity.trackable.folder.group ? (
                <React.Fragment>
                  <Link
                    component={WrappedNavLink}
                    to={ROUTES.user.home.path()}
                  >
                    to=
                    {ROUTES.admin.manage.resources.folders.show.path(activity.trackable_id)}
                  </Link>
                </React.Fragment>
              ) : activity.trackable.folder.enterprise ? (
                <React.Fragment>
                  <Link
                    component={WrappedNavLink}
                    to={ROUTES.group.manage.resources.folders.show.path(activity.trackable.group.id, activity.trackable_id)}
                  >
                    {activity.trackable.folder.name}
                  </Link>
                </React.Fragment>
              ) : <React.Fragment />}
              {'  '}
            </React.Fragment>
          ) : activity.trackable.news_feed_link ? (
            <React.Fragment>
              { activity.trackable.news_feed_link.news_link ? (
                <React.Fragment>
                  <Link
                    component={WrappedNavLink}
                    to={ROUTES.group.news.news_links.show.path(activity.trackable.group.id, activity.trackable_id)}
                  >
                    {activity.trackable.news_feed_link.news_link.title}
                  </Link>
                </React.Fragment>
              ) : (
                <React.Fragment>
                  {' viewed a news link which has since been removed  '}
                </React.Fragment>
              )}
            </React.Fragment>
          ) : <React.Fragment />}
        </React.Fragment>
      ) : (
        <React.Fragment>
          {' viewed an item which has since been removed '}
        </React.Fragment>
      )}
      {' at '}
      { formatDateTimeString(activity.created_at, DateTime.DATETIME_FULL) }
    </React.Fragment>
  );
}

ViewTrack.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(ViewTrack);
