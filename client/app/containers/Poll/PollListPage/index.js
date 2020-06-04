/**
 *
 * PollListPage
 *
 */

import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import saga from 'containers/Poll/saga';
import reducer from 'containers/Poll/reducer';

import { ROUTES } from 'containers/Shared/Routes/constants';

import {
  selectPaginatedPolls,
  selectPollsTotal,
  selectIsFetchingPolls,
  selectHasChanged
} from 'containers/Poll/selectors';
import { getPollsBegin, pollsUnmount, deletePollBegin } from 'containers/Poll/actions';
import { selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';

import PollList from 'components/Poll/PollList/Loadable';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';
import { createRedirectAction } from 'utils/reduxPushHelper';

const handlePollEdit = createRedirectAction(ROUTES.admin.include.polls.edit.path);

export function PollListPage(props) {
  useInjectReducer({ key: 'polls', reducer });
  useInjectSaga({ key: 'polls', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  const links = {
    pollNew: ROUTES.admin.include.polls.new.path(),
    pollPage: id => '/', // ROUTES.admin.manage.polls.show.path(id)
  };

  useEffect(() => {
    props.getPollsBegin(params);

    return () => {
      props.pollsUnmount();
    };
  }, []);

  useEffect(() => {
    if (props.hasChanged)
      props.getPollsBegin(params);

    return () => {
      props.pollsUnmount();
    };
  }, [props.hasChanged]);

  const handlePagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    props.getPollsBegin(newParams);
    setParams(newParams);
  };

  const handleOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    props.getPollsBegin(newParams);
    setParams(newParams);
  };

  return (
    <React.Fragment>
      <PollList
        polls={props.polls}
        pollTotal={props.pollTotal}
        isLoading={props.isLoading}
        deletePollBegin={props.deletePollBegin}
        handlePollEdit={props.handlePollEdit}
        handlePagination={handlePagination}
        handleOrdering={handleOrdering}
        links={links}
        currentEnterprise={props.currentEnterprise}
      />
    </React.Fragment>
  );
}

PollListPage.propTypes = {
  getPollsBegin: PropTypes.func.isRequired,
  pollsUnmount: PropTypes.func.isRequired,
  polls: PropTypes.array,
  pollTotal: PropTypes.number,
  deletePollBegin: PropTypes.func,
  isLoading: PropTypes.bool,
  handlePollEdit: PropTypes.func,
  hasChanged: PropTypes.bool,

  currentEnterprise: PropTypes.shape({
    id: PropTypes.number,
  })
};

const mapStateToProps = createStructuredSelector({
  polls: selectPaginatedPolls(),
  pollTotal: selectPollsTotal(),
  isLoading: selectIsFetchingPolls(),
  currentEnterprise: selectEnterprise(),
  permissions: selectPermissions(),
  hasChanged: selectHasChanged(),
});

const mapDispatchToProps = {
  getPollsBegin,
  pollsUnmount,
  deletePollBegin,
  handlePollEdit,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(Conditional(
  PollListPage,
  ['permissions.polls_create'],
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.poll.listPage
));
