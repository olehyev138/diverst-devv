import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/User/UserPolicy/reducer';
import saga from 'containers/User/UserPolicy/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser } from 'containers/Shared/App/selectors';
import { selectPolicy, selectIsCommitting, selectIsFetchingPolicy } from 'containers/User/UserPolicy/selectors';

import {
  getPolicyBegin, updatePolicyBegin,
  policiesUnmount
} from 'containers/User/UserPolicy/actions';

import PolicyForm from 'components/GlobalSettings/PolicyTemplate/PolicyForm';
import Conditional from 'components/Compositions/Conditional';

export function PolicyEditPage(props) {
  useInjectReducer({ key: 'policies', reducer });
  useInjectSaga({ key: 'policies', saga });

  const rs = new RouteService(useContext);
  const links = {
    policiesIndex: ROUTES.admin.system.users.policy_templates.index.path(),
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
)(Conditional(
  PolicyEditPage,
  ['currentPolicy.permissions.update?', 'isFormLoading'],
  (props, rs) => ROUTES.admin.system.users.policy_templates.index.path(),
  'user.userPolicy.policyTemplateEditPage'
));
