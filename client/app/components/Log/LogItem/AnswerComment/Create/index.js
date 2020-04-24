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
export function AnswerCommentCreate(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <React.Fragment>
      <LogOwner activity={activity} />
      {' created comment on answer '}
      { activity.trackable ? (
        <React.Fragment>
          { activity.trackable.answer.question ? (
            <React.Fragment>
              {' for question '}
              <Link
                component={WrappedNavLink}
                to={ROUTES.user.home.path()}
              >
                {activity.trackable.answer.question.title}
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

AnswerCommentCreate.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(AnswerCommentCreate);
