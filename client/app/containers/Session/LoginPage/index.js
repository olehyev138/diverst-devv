/**
 *
 * LoginPage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import { withStyles } from '@material-ui/core/styles';
import { showSnackbar } from 'containers/Shared/Notifier/actions';
import { selectEnterprise } from 'containers/Shared/App/selectors';
import { selectFormErrors } from './selectors';
import { push } from 'connected-react-router';

import reducer from './reducer';
import injectReducer from 'utils/injectReducer';

import LoginForm from 'components/Session/LoginForm';
import EnterpriseForm from 'components/Session/EnterpriseForm';

import {
  loginBegin,
  findEnterpriseBegin,
  ssoLoginBegin,
  ssoLinkBegin
}
  from 'containers/Shared/App/actions';

const styles = theme => ({});

export class LoginPage extends React.PureComponent {
  // TODO: - locale toggle

  constructor(props) {
    super(props);
    this.state = { email: '' };
  }

  componentDidMount() {
    if (this.props.location) {
      /* global URLSearchParams */
      const query = new URLSearchParams(this.props.location.search);
      const userToken = query.get('userToken');
      const policyGroupId = query.get('policyGroupId');
      const errorMessage = query.get('errorMessage');

      if (errorMessage) {
        this.props.showSnackbar(errorMessage);
        this.props.refresh('login');
      }

      if (userToken && policyGroupId)
        this.props.ssoLoginBegin({ policyGroupId, userToken });
    }
  }

  authForm() {
    if (this.props.enterprise && !this.props.enterprise.has_enabled_saml)
      return (
        <LoginForm
          email={this.state.email}
          formErrors={this.props.formErrors}
          loginBegin={(values, actions) => this.props.loginBegin(values)}
        />
      );


    if (this.props.enterprise && this.props.enterprise.has_enabled_saml) {
      this.props.ssoLinkBegin({ enterpriseId: this.props.enterprise.id });
      return (
        <EnterpriseForm
          formErrors={this.props.formErrors}
          findEnterpriseBegin={(values, actions) => {
            this.props.ssoLinkBegin({ enterpriseId: this.props.enterprise.id });
            this.setState({ email: values.email });
          }}
        />
      );
    }

    return (
      <EnterpriseForm
        formErrors={this.props.formErrors}
        findEnterpriseBegin={(values, actions) => {
          this.props.findEnterpriseBegin(values);
          this.setState({ email: values.email });
        }}
      />
    );
  }

  render() {
    return (
      this.authForm()
    );
  }
}

LoginPage.propTypes = {
  enterprise: PropTypes.shape({
    id: PropTypes.number,
    name: PropTypes.string,
    has_enabled_saml: PropTypes.bool
  }),
  formErrors: PropTypes.shape({
    email: PropTypes.string,
    password: PropTypes.string,
  }),
  location: PropTypes.shape({
    search: PropTypes.string
  }),
  showSnackbar: PropTypes.func,
  refresh: PropTypes.func,
  loginBegin: PropTypes.func,
  ssoLoginBegin: PropTypes.func,
  ssoLinkBegin: PropTypes.func,
  findEnterpriseBegin: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise(),
  formErrors: selectFormErrors(),
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

const withReducer = injectReducer({ key: 'loginPage', reducer });

export default compose(
  withReducer,
  withConnect,
  memo,
  withStyles(styles),
)(LoginPage);
