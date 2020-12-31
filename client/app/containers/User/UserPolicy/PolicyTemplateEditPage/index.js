import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/User/UserPolicy/reducer';
import saga from 'containers/User/UserPolicy/saga';

import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectUser, selectCustomText } from 'containers/Shared/App/selectors';
import { selectPolicy, selectIsCommitting, selectIsFetchingPolicy } from 'containers/User/UserPolicy/selectors';

import {
  getPolicyBegin, updatePolicyBegin,
  policiesUnmount
} from 'containers/User/UserPolicy/actions';

import PolicyForm from 'components/GlobalSettings/PolicyTemplate/PolicyForm';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function PolicyEditPage(props) {
  useInjectReducer({ key: 'policies', reducer });
  useInjectSaga({ key: 'policies', saga });

  const { policy_id: policyId } = useParams();

  const links = {
    policiesIndex: ROUTES.admin.system.users.policy_templates.index.path(),
  };

  useEffect(() => {
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
      customTexts={props.customTexts}
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
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentPolicy: selectPolicy(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFetchingPolicy(),
  customTexts: selectCustomText(),
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
  (props, params) => ROUTES.admin.system.users.policy_templates.index.path(),
  permissionMessages.user.userPolicy.policyTemplateEditPage
));
