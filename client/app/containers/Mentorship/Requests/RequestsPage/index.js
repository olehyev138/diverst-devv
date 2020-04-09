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
  selectIsFetchingRequests,
  selectSuccessfulChange
} from 'containers/Mentorship/Requests/selectors';
import {
  getProposalsBegin,
  getRequestsBegin,
  requestUnmount,
  acceptRequestBegin,
  rejectRequestBegin,
  deleteRequestBegin,
} from 'containers/Mentorship/Requests/actions';

import reducer from 'containers/Mentorship/Requests/reducer';
import saga from 'containers/Mentorship/Requests/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import RequestList from 'components/Mentorship/MentorRequestList';
import Conditional from 'components/Compositions/Conditional';
import dig from 'object-dig';
import { selectUser } from 'containers/Mentorship/selectors';
import permissionMessages from 'containers/Shared/Permissions/messages';


const defaultParams = Object.freeze({
  count: 5,
  page: 0,
  order: 'asc'
});

export function MentorsPage(props) {
  useInjectReducer({ key: 'request', reducer });
  useInjectSaga({ key: 'request', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc', orderBy: 'id' });

  const rs = new RouteService(useContext);

  const validType = type => type === 'outgoing' || type === 'incoming';

  function getRequests(newParams = params) {
    if (props.user && validType(props.type)) {
      const userId = props.user.id;

      if (props.type === 'outgoing')
        props.getProposalsBegin({ ...newParams, userId });
      else
        props.getRequestsBegin({ ...newParams, userId });
    }
  }

  useEffect(() => {
    getRequests();

    return () => {
      props.requestUnmount();
    };
  }, []);

  useEffect(() => {
    if (props.successfulChange)
      getRequests();
  }, [props.successfulChange]);

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
        userSession={props.userSession}
        userParams={params}

        requests={requests}
        requestsTotal={requestsTotal}
        isFetchingRequests={isFetchingRequests}

        handleRequestPagination={handleRequestPagination}
        handleRequestOrdering={handleRequestOrdering}

        params={params}
        type={props.type}

        acceptRequest={props.acceptRequestBegin}
        rejectRequest={props.rejectRequestBegin}
        deleteRequest={props.deleteRequestBegin}
      />
    </React.Fragment>
  );
}

MentorsPage.propTypes = {
  type: PropTypes.string,
  user: PropTypes.object,
  userSession: PropTypes.shape({
    id: PropTypes.number
  }).isRequired,

  getProposalsBegin: PropTypes.func.isRequired,
  getRequestsBegin: PropTypes.func.isRequired,

  requests: PropTypes.array,
  requestsTotal: PropTypes.number,
  isFetchingRequests: PropTypes.bool,

  requestUnmount: PropTypes.func.isRequired,

  acceptRequestBegin: PropTypes.func.isRequired,
  rejectRequestBegin: PropTypes.func.isRequired,
  deleteRequestBegin: PropTypes.func.isRequired,

  successfulChange: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  requests: selectPaginatedRequests(),
  requestsTotal: selectRequestsTotal(),
  isFetchingRequests: selectIsFetchingRequests(),
  successfulChange: selectSuccessfulChange(),
});

const mapDispatchToProps = {
  getProposalsBegin,
  getRequestsBegin,
  requestUnmount,
  acceptRequestBegin,
  rejectRequestBegin,
  deleteRequestBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  MentorsPage,
  ['user.permissions.update?'],
  (props, rs) => ROUTES.user.mentorship.show.path(dig(props, 'sessionUser', 'user_id')),
  permissionMessages.mentorship.requests.indexPage,
  true
));
