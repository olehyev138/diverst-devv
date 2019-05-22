/**
 *
 * LoginPage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { FormattedMessage } from 'react-intl';
import { selectEnterprise } from 'containers/App/selectors';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import injectReducer from 'utils/injectReducer';

import reducer from './reducer';

import LoginForm from '../../components/LoginForm';
import EnterpriseForm from '../../components/EnterpriseForm';

import { handleLogin, handleFindEnterprise } from 'containers/App/actions';

import "./index.css";

export class LoginPage extends React.PureComponent {

  // TODO: - use formik actions
  //       - locale toggle

  constructor(props) {
    super(props);
    this.state = { email: '' }
  }

  authForm() {
    if (this.props.enterprise) {
      return <LoginForm email={this.state.email} onLogin={(values, actions) => this.props.handleLogin(values)}/>
    }
    else {
      return <EnterpriseForm onFindEnterprise={(values, actions) => {
        this.props.handleFindEnterprise(values);
        this.setState({ email: values.email });
      }}
      />;
    }
  };

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
  handleLogin: PropTypes.func,
  handleFind: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  enterprise: selectEnterprise()
});

function mapDispatchToProps(dispatch) {
  return {
    handleLogin: (payload) => dispatch(handleLogin(payload)),
    handleFindEnterprise: (payload) => dispatch(handleFindEnterprise(payload))
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
)(LoginPage);
