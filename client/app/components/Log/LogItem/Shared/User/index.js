import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import { DateTime } from 'luxon';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { Link, Avatar } from '@material-ui/core';
import DiverstImg from 'components/Shared/DiverstImg';

// This component for displaying log owner
export function SharedUser(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <React.Fragment>
      { activity.trackable ? (
        <React.Fragment>
          <Avatar>
            { activity.trackable.avatar ? (
              <DiverstImg
                data={activity.trackable.avatar_data}
                maxWidth='100%'
                maxHeight='240px'
              />
            ) : (
              activity.trackable.first_name[0]
            )}
          </Avatar>
          <Link
            component={WrappedNavLink}
            to={ROUTES.user.show.path(activity.trackable_id)}
          >
            {activity.trackable.first_name}
          </Link>
        </React.Fragment>
      ) : <React.Fragment />}
    </React.Fragment>
  );
}

SharedUser.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(SharedUser);
