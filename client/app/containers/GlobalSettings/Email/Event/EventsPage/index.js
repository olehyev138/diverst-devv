import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import saga from 'containers/GlobalSettings/Email/Email/saga';
import reducer from 'containers/GlobalSettings/Email/Email/reducer';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  selectPaginatedEmails,
  selectIsFetchingEmails,
  selectEmailsTotal
} from 'containers/GlobalSettings/Email/Email/selectors';
import { selectUser } from 'containers/Shared/App/selectors';

import {
  emailsUnmount, getEmailsBegin,
} from 'containers/GlobalSettings/Email/Email/actions';

import EmailsList from 'components/GlobalSettings/Email/EmailsList';
import dig from 'object-dig';

const defaultParams = Object.freeze({
  count: 10, // TODO: Make this a constant and use it also in EventsList
  page: 0,
  order: 'asc',
  orderBy: 'id',
});

export function CustomTextEditPage(props) {
  useInjectReducer({ key: 'emails', reducer });
  useInjectSaga({ key: 'emails', saga });

  const rs = new RouteService(useContext);
  const links = {
    emailEdit: id => ROUTES.admin.system.globalSettings.emails.edit.path(id),
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

CustomTextEditPage.propTypes = {
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
)(CustomTextEditPage);
