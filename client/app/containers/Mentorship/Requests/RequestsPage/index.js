/**
 *
 * RequestsPage
 *
 *  - lists all enterprise custom users
 *  - renders forms for creating & editing custom users
 *
 *  - function:
 *    - get users from server
 *    - on edit - render respective form with user data
 *    - on new - render respective empty form
 *    - on save - create/update user
 */

import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { push } from 'connected-react-router';

import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import {
  selectPaginatedRequests,
  selectRequestsTotal,
  selectRequest,
  selectIsFetchingRequests
} from 'containers/Mentorship/Requests/selectors';
import {
  getProposalsBegin,
  getRequestsBegin,
  requestUnmount,
  acceptRequestBegin,
  denyRequestBegin,
} from 'containers/Mentorship/Requests/actions';

import reducer from 'containers/Mentorship/Requests/reducer';
import saga from 'containers/Mentorship/Requests/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import RequestList from 'components/Mentorship/MentorRequestList';


const defaultParams = Object.freeze({
  count: 5,
  page: 0,
  order: 'asc'
});

export function MentorsPage(props) {
  useInjectReducer({ key: 'request', reducer });
  useInjectSaga({ key: 'request', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  const rs = new RouteService(useContext);

  const validType = type => type === 'outgoing' || type === 'incoming';

  function getRequests(params = params, resetParams = false) {
    if (props.user && validType(props.type)) {
      if (resetParams)
        setParams({ ...params, page: defaultParams.page });

      const userId = props.user.id;
      if (props.type === 'outgoing')
        props.getProposalsBegin({ ...params, userId });
      else
        props.getRequestsBegin({ ...params, userId });
    }
  }

  useEffect(() => {
    getRequests();

    return () => {
      props.requestUnmount();
    };
  }, []);


  const handleRequestPagination = (payload) => {
    const oldPageNum = params.page;
    const oldRows = params.count;
    let newPageNum = payload.page;
    const newRows = payload.count;

    if (oldRows !== newRows) {
      const index = oldPageNum * oldRows + 1;
      newPageNum = Math.floor(index / newRows);
    }

    const newParams = { ...params, count: newRows, page: newPageNum };

    getRequests(newParams);
    setParams(newParams);
    return newParams;
  };

  const handleRequestOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    getRequests(newParams);
    setParams(newParams);
  };


  const { requests, requestsTotal, isFetchingRequests } = props;

  return (
    <React.Fragment>
      <RequestList
        user={props.user}
        userParams={params}

        requests={requests}
        requestsTotal={requestsTotal}
        isFetchingRequests={isFetchingRequests}

        handleMentorPagination={handleRequestPagination}
        handleMentorOrdering={handleRequestOrdering}

        params={params}
        type={props.type}

        acceptRequest={props.acceptRequestBegin}
        rejectRequest={props.denyRequestBegin}
      />
    </React.Fragment>
  );
}

MentorsPage.propTypes = {
  type: PropTypes.string,
  user: PropTypes.object,

  getProposalsBegin: PropTypes.func.isRequired,
  getRequestsBegin: PropTypes.func.isRequired,

  requests: PropTypes.array,
  requestsTotal: PropTypes.number,
  isFetchingRequests: PropTypes.bool,

  requestUnmount: PropTypes.func.isRequired,

  acceptRequestBegin: PropTypes.func.isRequired,
  denyRequestBegin: PropTypes.func.isRequired,
};

const mapStateToProps = createStructuredSelector({
  requests: selectPaginatedRequests(),
  requestsTotal: selectRequestsTotal(),
  isFetchingRequests: selectIsFetchingRequests(),
});

const mapDispatchToProps = {
  getProposalsBegin,
  getRequestsBegin,
  requestUnmount,
  acceptRequestBegin,
  denyRequestBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(MentorsPage);
