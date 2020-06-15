// mock store for GroupManageLayout
import React from 'react';
import GroupManageLayout from '../index';
import PropTypes from 'prop-types';

function MockGroupManageLayout(props) {
  return (
    <div>
      <GroupManageLayout {...props} />
    </div>
  );
}

MockGroupManageLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  defaultPage: PropTypes.bool,
  currentGroup: PropTypes.object,
};

export default MockGroupManageLayout;
