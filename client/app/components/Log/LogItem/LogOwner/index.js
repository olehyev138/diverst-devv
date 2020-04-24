import React, { memo } from 'react';
import { compose } from 'redux';
import PropTypes from 'prop-types';
import { Link } from '@material-ui/core';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { ROUTES } from 'containers/Shared/Routes/constants';

// This component for displaying log owner
export function LogOwner(props) {
  const { rowData, ...rest } = props;

  return (
    <React.Fragment>
      {rowData && (
        <Link
          component={WrappedNavLink}
          to={{
            pathname: ROUTES.user.show.path(rowData.owner_id),
            state: { id: rowData.owner_id }
          }}
        >
          {rowData.user.name}
        </Link>
      )}
    </React.Fragment>
  );
}

LogOwner.propTypes = {
  rowData: PropTypes.object,
};

export default compose(
  memo,
)(LogOwner);
