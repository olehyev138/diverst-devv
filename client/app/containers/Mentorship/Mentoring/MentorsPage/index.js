/**
 *
 * MentorsPage
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
  selectPaginatedUsers,
  selectUsersTotal,
  selectIsFetchingUsers,
} from 'containers/Mentorship/Mentoring/selectors';
import {
  getMentorsBegin, getMenteesBegin,
  getAvailableMentorsBegin, getAvailableMenteesBegin,
  mentorsUnmount
} from 'containers/Mentorship/Mentoring/actions';

import reducer from 'containers/Mentorship/Mentoring/reducer';
import saga from 'containers/Mentorship/Mentoring/saga';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import MentorList from 'components/Mentorship/MentorList';

const Types = Object.freeze({
  current: 0,
  available: 1,
});

export function MentorsPage(props) {
  useInjectReducer({ key: 'mentoring', reducer });
  useInjectSaga({ key: 'mentoring', saga });

  const [params, setParams] = useState({ count: 5, page: 0, order: 'asc' });
  const [tab, setTab] = useState(Types.current);

  const rs = new RouteService(useContext);

  function getUsers(tab, params = params) {
    if (props.user) {
      const userId = props.user.id;
      if (tab === Types.current)
        props.getMentorsBegin({ ...params, objectId: userId, association: props.type });
      else
        props.getAvailableMentorsBegin({ ...params, $id: userId, query_scopes: [props.type] });
    }
  }

  useEffect(() => {
    getUsers(Types.current);

    return () => {
      props.mentorsUnmount();
    };
  }, []);

  const links = {
    userNew: ROUTES.admin.system.users.new.path(),
    userEdit: id => ROUTES.admin.system.users.edit.path(id),
  };

  const handleMentorPagination = (payload) => {
    const newParams = { ...params, count: payload.count, page: payload.page };

    getUsers(tab, newParams);
    setParams(newParams);
  };

  const handleMentorOrdering = (payload) => {
    const newParams = { ...params, orderBy: payload.orderBy, order: payload.orderDir };

    getUsers(tab, newParams);
    setParams(newParams);
  };

  const handleChangeTab = (event, newTab) => {
    setTab(newTab);
    switch (newTab) {
      case Types.current:
        getUsers(Types.current);
        break;
      case Types.available:
        getUsers(Types.available);
        break;
      default:
        break;
    }
  };

  return (
    <React.Fragment>
      <MentorList
        user={props.user}
        userParams={params}

        users={props.users}
        userTotal={props.userTotal}
        isFetchingUsers={props.isFetchingUsers}

        handleMentorPagination={handleMentorPagination}
        handleMentorOrdering={handleMentorOrdering}
        type={props.type}
        links={links}

        currentTab={tab}
        handleChangeTab={handleChangeTab}
      />
    </React.Fragment>
  );
}

MentorsPage.propTypes = {
  type: PropTypes.string,
  user: PropTypes.object,
  getMentorsBegin: PropTypes.func.isRequired,
  getAvailableMentorsBegin: PropTypes.func.isRequired,
  users: PropTypes.array,
  userTotal: PropTypes.number,
  isFetchingUsers: PropTypes.bool,
  mentorsUnmount: PropTypes.func.isRequired,
};

const mapStateToProps = createStructuredSelector({
  users: selectPaginatedUsers(),
  userTotal: selectUsersTotal(),
  isFetchingUsers: selectIsFetchingUsers(),
});

const mapDispatchToProps = {
  getMentorsBegin,
  getMenteesBegin,
  getAvailableMentorsBegin,
  getAvailableMenteesBegin,
  mentorsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(MentorsPage);
