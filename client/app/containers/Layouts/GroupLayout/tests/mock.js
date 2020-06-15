// mock store for GroupLayout
import React from 'react';
import GroupLayout from '../index';
import PropTypes from 'prop-types';

function MockGroupLayout(props) {
  return (
    <div>
      <GroupLayout {...props} />
    </div>
  );
}

MockGroupLayout.propTypes = {
  component: PropTypes.elementType,
  classes: PropTypes.object,
  currentGroup: PropTypes.object,
  disableBreadcrumbs: PropTypes.bool,
  grouphasChanged: PropTypes.bool,
};

export default MockGroupLayout;
