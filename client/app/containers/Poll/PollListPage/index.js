/**
 *
 * PollListPage
 *
 */

import React, {
  memo, useContext, useEffect, useState
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import saga from 'containers/Poll/saga';
import reducer from 'containers/Poll/reducer';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import { selectPaginatedPolls, selectPollsTotal, selectIsFetchingPolls } from 'containers/Poll/selectors';
import { getPollsBegin, pollsUnmount, deletePollBegin } from 'containers/Poll/actions';
import { selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';

import PollList from 'components/Poll/PollList';
import { push } from 'connected-react-router';
import Conditional from 'components/Compositions/Conditional';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function PollListPage(props) {
  useInjectReducer({ key: 'polls', reducer });
  useInjectSaga({ key: 'polls', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });

  const rs = new RouteService(useContext);
  const links = {
    pollNew: '/', // ROUTES.admin.manage.polls.new.path(),
    pollPage: id => '/', // ROUTES.admin.manage.polls.show.path(id)
  };

  useEffect(() => {
    props.getPollsBegin(params);

    return () => {
      props.pollUnmount();
    };
  }, []);

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
  pollUnmount: PropTypes.func.isRequired,
  polls: PropTypes.array,
  pollTotal: PropTypes.number,
  deletePollBegin: PropTypes.func,
  isLoading: PropTypes.bool,
  handlePollEdit: PropTypes.func,

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
});
/*
const mapDispatchToProps = {
  getPollsBegin,
  pollUnmount,
  deletePollBegin,
};
*/
const mapDispatchToProps = dispatch => ({
  getPollsBegin: payload => dispatch(getPollsBegin(payload)),
  deletePollBegin: payload => dispatch(deletePollBegin(payload)),
  pollUnmount: () => dispatch(pollsUnmount()),
  handlePollEdit: id => dispatch(push(ROUTES.admin.manage.polls.edit.path(id)))
});

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
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.poll.listPage
));
