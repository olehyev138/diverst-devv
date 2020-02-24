import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/GlobalSettings/Policy/reducer';
import saga from 'containers/GlobalSettings/Policy/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectPolicy, selectIsCommitting, selectIsFetchingPolicy } from 'containers/GlobalSettings/Policy/selectors';

import {
  getPolicyBegin, updatePolicyBegin,
  policiesUnmount
} from 'containers/GlobalSettings/Policy/actions';

import PolicyForm from 'components/GlobalSettings/PolicyTemplate/PolicyForm';

export function PolicyEditPage(props) {
  useInjectReducer({ key: 'policies', reducer });
  useInjectSaga({ key: 'policies', saga });

  const rs = new RouteService(useContext);
  const links = {
    policiesIndex: ROUTES.admin.system.globalSettings.policy_templates.index.path(),
  };

  useEffect(() => {
    const policyId = rs.params('policy_id');
    props.getPolicyBegin({ id: policyId });

    return () => props.policiesUnmount();
  }, []);

  const { currentUser, currentGroup, currentPolicy } = props;

  return (
    <PolicyForm
      edit
      policyAction={props.updatePolicyBegin}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
      policy={currentPolicy}
      links={links}
    />
  );
}

PolicyEditPage.propTypes = {
  getPolicyBegin: PropTypes.func,
  updatePolicyBegin: PropTypes.func,
  policiesUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentPolicy: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentPolicy: selectPolicy(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFetchingPolicy(),
});

const mapDispatchToProps = {
  getPolicyBegin,
  updatePolicyBegin,
  policiesUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(PolicyEditPage);
