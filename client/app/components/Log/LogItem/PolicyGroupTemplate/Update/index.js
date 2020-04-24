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
export function PolicyGroupTemplateUpdate(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <React.Fragment>
      <LogOwner activity={activity} />
      {' updated policy group template '}
      <Link
        component={WrappedNavLink}
        to={ROUTES.admin.system.users.policy_templates.edit.path(activity.trackable_id)}
      >
        {activity.trackable.name}
      </Link>
      {' at '}
      { formatDateTimeString(activity.created_at, DateTime.DATETIME_FULL) }
    </React.Fragment>
  );
}

PolicyGroupTemplateUpdate.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(PolicyGroupTemplateUpdate);
