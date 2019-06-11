/**
 *
 * LoginPage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { FormattedMessage } from 'react-intl';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';
import { withStyles } from '@material-ui/core/styles';

import { selectEnterprise } from 'containers/App/selectors';
import { selectEmailError, selectPasswordError } from './selectors';

import reducer from './reducer';
import injectReducer from 'utils/injectReducer';

import LoginForm from '../../components/LoginForm';
import EnterpriseForm from '../../components/EnterpriseForm';

import { loginBegin, findEnterpriseBegin } from 'containers/App/actions';

const styles = theme => ({});

export class LoginPage extends React.PureComponent {
  constructor(props) {
    super(props);
    this.state = { email: '' };
  }

  authForm() {
    if (this.props.enterprise)
      return (
        <LoginForm
          email={this.state.email}
          passwordError={this.props.passwordError}
          loginBegin={(values, actions) => this.props.loginBegin(values)}
        />
      );

    return (
      <EnterpriseForm
        emailError={this.props.emailError}
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
    name: PropTypes.string
  }),
  passwordError: PropTypes.string,
  emailError: PropTypes.string,
  loginBegin: PropTypes.func,
  findEnterpriseBegin: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise(),
  emailError: selectEmailError(),
  passwordError: selectPasswordError(),
});

function mapDispatchToProps(dispatch) {
  return {
    loginBegin: payload => dispatch(loginBegin(payload)),
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
