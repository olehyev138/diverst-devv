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
              { activity.trackable.resource.container.group ? (
                <React.Fragment>
                  <Link
                    component={WrappedNavLink}
                    to={ROUTES.user.home.path()}
                  >
                    {activity.trackable.resource.title}
                  </Link>
                </React.Fragment>
              ) : activity.trackable.resource.container.enterprise ? (
                <React.Fragment>
                  <Link
                    component={WrappedNavLink}
                    to={ROUTES.user.home.path()}
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
                to={ROUTES.user.home.path()}
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
                    {activity.trackable.folder.name}
                  </Link>
                </React.Fragment>
              ) : activity.trackable.folder.enterprise ? (
                <React.Fragment>
                  <Link
                    component={WrappedNavLink}
                    to={ROUTES.user.home.path()}
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
                    to={ROUTES.user.home.path()}
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
