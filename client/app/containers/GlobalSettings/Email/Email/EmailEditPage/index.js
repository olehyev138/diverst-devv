import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/GlobalSettings/Email/Email/reducer';
import saga from 'containers/GlobalSettings/Email/Email/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectGroup } from 'containers/Group/selectors';
import { selectPermissions, selectUser } from 'containers/Shared/App/selectors';
import { selectEmail, selectIsCommitting, selectIsFetchingEmail } from 'containers/GlobalSettings/Email/Email/selectors';

import {
  getEmailBegin, updateEmailBegin,
  emailsUnmount
} from 'containers/GlobalSettings/Email/Email/actions';

import EmailForm from 'components/GlobalSettings/Email/EmailForm';
import Conditional from 'components/Compositions/Conditional';
import { SSOSettingsPage } from 'containers/GlobalSettings/SSOSettingsPage';

export function EmailEditPage(props) {
  useInjectReducer({ key: 'emails', reducer });
  useInjectSaga({ key: 'emails', saga });

  const rs = new RouteService(useContext);
  const links = {
    emailsIndex: ROUTES.admin.system.globalSettings.emails.index.path(),
    emailEdit: ROUTES.admin.system.globalSettings.emails.edit.path(rs.params('email_id')),
  };

  useEffect(() => {
    const emailId = rs.params('email_id');
    props.getEmailBegin({ id: emailId });

    return () => props.emailsUnmount();
  }, []);

  const { currentUser, currentGroup, currentEmail } = props;

  return (
    <EmailForm
      edit
      emailAction={props.updateEmailBegin}
      isCommitting={props.isCommitting}
      isFormLoading={props.isFormLoading}
      currentUser={currentUser}
      currentGroup={currentGroup}
      email={currentEmail}
      links={links}
    />
  );
}

EmailEditPage.propTypes = {
  getEmailBegin: PropTypes.func,
  updateEmailBegin: PropTypes.func,
  emailsUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  currentGroup: PropTypes.object,
  currentEmail: PropTypes.object,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentGroup: selectGroup(),
  currentUser: selectUser(),
  currentEmail: selectEmail(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFetchingEmail(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getEmailBegin,
  updateEmailBegin,
  emailsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  EmailEditPage,
  ['permissions.emails_manage'],
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  'globalSettings.email.email.editPage'
));
