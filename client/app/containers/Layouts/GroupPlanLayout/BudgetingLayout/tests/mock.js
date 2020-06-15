// mock store for BudgetLayout
import React from 'react';
import BudgetLayout from '../index';
import PropTypes from 'prop-types';

function MockBudgetLayout(props) {
  return (
    <div>
      <BudgetLayout {...props} />
    </div>
  );
}

MockBudgetLayout.propTypes = {
  classes: PropTypes.object,
  component: PropTypes.elementType,
  pageTitle: PropTypes.object,
  location: PropTypes.object,
  defaultPage: PropTypes.bool,
  computedMatch: PropTypes.object,
  currentGroup: PropTypes.object,
};

export default MockBudgetLayout;
