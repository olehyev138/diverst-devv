// mock store for system user layout
import React from 'react';
import SystemUsersLayout from '../index';
import PropTypes from 'prop-types';

function MockSystemUsersLayout(props) {
  return (
    <div>
      <SystemUsersLayout {...props} />
    </div>
  );
}

MockSystemUsersLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  permissions: PropTypes.object,
};

export default MockSystemUsersLayout;
