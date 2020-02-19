/**
 *
 * LoginPage
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import { push } from 'connected-react-router';

import { useInjectReducer } from 'utils/injectReducer';

import reducer from './reducer';

import { CircularProgress, Backdrop } from '@material-ui/core';

import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { loginBegin, findEnterpriseBegin, ssoLoginBegin, ssoLinkBegin } from 'containers/Shared/App/actions';

import { selectEnterprise } from 'containers/Shared/App/selectors';
import { selectIsLoggingIn, selectLoginSuccess } from './selectors';

import LoginForm from 'components/Session/LoginForm';
import EnterpriseForm from 'components/Session/EnterpriseForm';

export function LoginPage(props) {
  useInjectReducer({ key: 'loginPage', reducer });

  const [email, setEmail] = useState('');

  useEffect(() => {
    /* global URLSearchParams */
    const query = new URLSearchParams(props.location.search);
    const enterpriseId = query.get('enterpriseId');

    if (!props.enterprise)
      props.findEnterpriseBegin(enterpriseId ? { enterprise_id: enterpriseId } : {});

    // SSO
    const userToken = query.get('userToken');
    const policyGroupId = query.get('policyGroupId');
    const errorMessage = query.get('errorMessage');

    if (errorMessage) {
      props.showSnackbar(errorMessage);
      props.refresh('login');
    }

    if (userToken && policyGroupId)
      props.ssoLoginBegin({ policyGroupId, userToken });
  }, []);

  const authForm = () => {
    if (props.enterprise) {
      if (props.enterprise.has_enabled_saml) {
        props.ssoLinkBegin({ enterpriseId: props.enterprise.id });
        return (
          <EnterpriseForm
            findEnterpriseBegin={(values, actions) => {
              props.ssoLinkBegin({ enterpriseId: props.enterprise.id });
              setEmail(values.email);
            }}
          />
        );
      }

      return (
        <LoginForm
          email={email}
          loginBegin={values => props.loginBegin(values)}
          isLoggingIn={props.isLoggingIn}
          loginSuccess={props.loginSuccess}
        />
      );
    }

    return null;
  };

  return (
    <React.Fragment>
      <Backdrop open={!props.enterprise}>
        <CircularProgress
          color='secondary'
          size={60}
          thickness={1}
        />
      </Backdrop>
      {authForm()}
    </React.Fragment>
  );
}

LoginPage.propTypes = {
  enterprise: PropTypes.object,
  location: PropTypes.shape({
    search: PropTypes.string
  }),
  showSnackbar: PropTypes.func,
  refresh: PropTypes.func,
  loginBegin: PropTypes.func,
  ssoLoginBegin: PropTypes.func,
  ssoLinkBegin: PropTypes.func,
  findEnterpriseBegin: PropTypes.func,
  isLoggingIn: PropTypes.bool,
  loginSuccess: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise(),
  isLoggingIn: selectIsLoggingIn(),
  loginSuccess: selectLoginSuccess(),
});

function mapDispatchToProps(dispatch) {
  return {
    showSnackbar: payload => dispatch(showSnackbar({ message: payload })),
    refresh: payload => dispatch(push(payload)),
    loginBegin: payload => dispatch(loginBegin(payload)),
    ssoLoginBegin: payload => dispatch(ssoLoginBegin(payload)),
    ssoLinkBegin: payload => dispatch(ssoLinkBegin(payload)),
    findEnterpriseBegin: payload => dispatch(findEnterpriseBegin(payload)),
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(LoginPage);
