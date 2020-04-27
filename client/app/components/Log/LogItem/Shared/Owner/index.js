import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { formatDateTimeString } from 'utils/dateTimeHelpers';
import { DateTime } from 'luxon';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { Link, Avatar, Box } from '@material-ui/core';
import DiverstImg from 'components/Shared/DiverstImg';

// This component for displaying log owner
export function SharedOwner(props) {
  const { activity, ...rest } = props;

  /* eslint no-nested-ternary: 0 */
  return (
    <React.Fragment>
      { activity.owner ? (
        <Box display='flex' alignItems='center' width='auto'>
          <Box order={1} mr={1}>
            <Avatar>
              { activity.owner.avatar ? (
                <DiverstImg
                  data={activity.owner.avatar_data}
                  maxWidth='100%'
                  maxHeight='240px'
                />
              ) : (
                activity.owner.first_name[0]
              )}
            </Avatar>
          </Box>
          <Box order={2}>
            <Link
              component={WrappedNavLink}
              to={ROUTES.user.show.path(activity.owner_id)}
            >
              {activity.owner.name_with_status}
            </Link>
          </Box>
        </Box>
      ) : (
        <React.Fragment>
          {' Unknown user '}
        </React.Fragment>
      )}
    </React.Fragment>
  );
}

SharedOwner.propTypes = {
  activity: PropTypes.object,
};

export default compose(
  memo,
)(SharedOwner);
