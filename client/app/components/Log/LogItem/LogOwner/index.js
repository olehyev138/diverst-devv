import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { Link } from '@material-ui/core';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

// This component for displaying log owner
export function LogOwner(props) {
  const { activity, ...rest } = props;

  return (
    <React.Fragment>
      {activity && (
        <Link
          component={WrappedNavLink}
          to={{
            pathname: ROUTES.user.show.path(activity.owner_id),
            state: { id: activity.owner_id }
          }}
        >
          {activity.user.name}
        </Link>
      )}
    </React.Fragment>
  );
}

LogOwner.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(LogOwner);
