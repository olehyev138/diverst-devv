import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import saga from 'containers/GlobalSettings/Email/Email/saga';
import reducer from 'containers/GlobalSettings/Email/Email/reducer';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  selectPaginatedEmails,
  selectIsFetchingEmails,
  selectEmailsTotal
} from 'containers/GlobalSettings/Email/Email/selectors';
import { selectPermissions, selectUser } from 'containers/Shared/App/selectors';

import {
  emailsUnmount, getEmailsBegin,
} from 'containers/GlobalSettings/Email/Email/actions';

import EmailsList from 'components/GlobalSettings/Email/EmailsList';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

const defaultParams = Object.freeze({
  count: 10, // TODO: Make this a constant and use it also in EventsList
  page: 0,
  order: 'asc',
  orderBy: 'id',
});

export function EmailsPage(props) {
  useInjectReducer({ key: 'emails', reducer });
  useInjectSaga({ key: 'emails', saga });

  const links = {
    emailEdit: id => ROUTES.admin.system.globalSettings.emails.layouts.edit.path(id),
  };

  const { currentUser, emails, isFetching } = props;

  const [params, setParams] = useState(defaultParams);

  const getEmails = (newParams = params) => {
    const updatedParams = {
      ...params,
      ...newParams,
    };
    props.getEmailsBegin(updatedParams);
    setParams(updatedParams);
  };

  useEffect(() => {
    getEmails();

    return () => {
      props.emailsUnmount();
    };
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    getEmails(newParams);
  };

  return (
    <EmailsList
      currentUser={currentUser}
      emails={emails}
      handlePagination={handlePagination}
      emailsTotal={props.emailsTotal}
      links={links}
      isLoading={isFetching}
    />
  );
}

EmailsPage.propTypes = {
  getEmailsBegin: PropTypes.func,
  emailsUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  emails: PropTypes.array,
  emailsTotal: PropTypes.number,
  isFetching: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  emails: selectPaginatedEmails(),
  emailsTotal: selectEmailsTotal(),
  isFetching: selectIsFetchingEmails(),
  permissions: selectPermissions(),
});

const mapDispatchToProps = {
  getEmailsBegin,
  emailsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  EmailsPage,
  ['permissions.emails_manage'],
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.globalSettings.email.email.indexPage
));
