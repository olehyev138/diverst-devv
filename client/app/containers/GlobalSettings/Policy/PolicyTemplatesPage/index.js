import React, {
  memo, useEffect, useState, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import saga from 'containers/GlobalSettings/Policy/saga';
import reducer from 'containers/GlobalSettings/Policy/reducer';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  selectPaginatedPolicies,
  selectIsFetchingPolicies,
  selectPoliciesTotal
} from 'containers/GlobalSettings/Policy/selectors';
import { selectUser } from 'containers/Shared/App/selectors';

import {
  policiesUnmount, getPoliciesBegin,
} from 'containers/GlobalSettings/Policy/actions';

// import PoliciesList from 'components/GlobalSettings/PolicysList';
import dig from 'object-dig';
import { NotFoundPage } from 'containers/Shared/Routes/templates';

const defaultParams = Object.freeze({
  count: 10, // TODO: Make this a constant and use it also in EventsList
  page: 0,
  order: 'asc',
  orderBy: 'id',
});

export function PolicyTemplatesPage(props) {
  useInjectReducer({ key: 'policies', reducer });
  useInjectSaga({ key: 'policies', saga });

  const rs = new RouteService(useContext);
  const links = {
    emailEdit: id => ROUTES.admin.system.globalSettings.policies.edit.path(id),
  };

  const { currentUser, policies, isFetching } = props;

  const [params, setParams] = useState(defaultParams);

  const getPolicies = (newParams = {}) => {
    const updatedParams = {
      ...params,
      ...newParams,
    };
    props.getPoliciesBegin(updatedParams);
    setParams(updatedParams);
  };

  useEffect(() => {
    getPolicies();

    return () => {
      props.policiesUnmount();
    };
  }, []);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    getPolicies(newParams);
  };

  return (
    <NotFoundPage />
  );
}

PolicyTemplatesPage.propTypes = {
  getPoliciesBegin: PropTypes.func,
  policiesUnmount: PropTypes.func,
  currentUser: PropTypes.object,
  policies: PropTypes.array,
  policiesTotal: PropTypes.number,
  isFetching: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  currentUser: selectUser(),
  policies: selectPaginatedPolicies(),
  policiesTotal: selectPoliciesTotal(),
  isFetching: selectIsFetchingPolicies(),
});

const mapDispatchToProps = {
  getPoliciesBegin,
  policiesUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(PolicyTemplatesPage);
