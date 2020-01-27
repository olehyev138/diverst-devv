import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import saga from 'containers/Group/saga';

import { createBudgetRequestBegin } from 'containers/Group/GroupPlan/Budget/actions';
import { selectGroupIsCommitting } from 'containers/Group/selectors';

import GroupForm from 'components/Group/GroupForm';

export function GroupCreatePage(props) {
  useInjectReducer({ key: 'budgets', reducer });
  useInjectSaga({ key: 'budgets', saga });

  useEffect(() => () => {}, []);

  return (
    <h1>
      THIS IS A FORM
    </h1>
  );
}

GroupCreatePage.propTypes = {
  createGroupBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  groupFormUnmount: PropTypes.func,
  groups: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectGroupIsCommitting(),
});

const mapDispatchToProps = {
  createBudgetRequestBegin
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupCreatePage);
