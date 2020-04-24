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
export function QuestionUpdate(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <React.Fragment>
      <LogOwner activity={activity} />
      {' updated question '}
      { activity.trackable ? (
        <React.Fragment>
          <Link
            component={WrappedNavLink}
            to={ROUTES.admin.innovate.campaigns.questions.show.path(activity.trackable.campaign.id, activity.trackable_id)}
          >
            {activity.trackable.title}
          </Link>
          { activity.trackable.campaign ? (
            <React.Fragment>
              {' for campaign '}
              <Link
                component={WrappedNavLink}
                to={ROUTES.admin.innovate.campaigns.show.path(activity.trackable.campaign.id)}
              >
                {activity.trackable.campaign.title}
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

QuestionUpdate.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(QuestionUpdate);
