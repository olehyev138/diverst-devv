// mock store for GroupPlanLayout
import React from 'react';
import GroupPlanLayout from '../index';
import PropTypes from 'prop-types';

function MockGroupPlanLayout(props) {
  return (
    <div>
      <GroupPlanLayout {...props} />
    </div>
  );
}

MockGroupPlanLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
};

export default MockGroupPlanLayout;
