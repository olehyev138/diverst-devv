import React, {
  memo, useEffect, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/User/UserLists/reducer';
import saga from 'containers/User/UserLists/saga';

import { getUsersBegin, userListUnmount } from 'containers/User/UserLists/actions';
import { selectPaginatedUsers } from 'containers/User/UserLists/selectors';
import RouteService from 'utils/routeHelpers';

import GroupMemberList from 'components/User/UserLists/GroupMemberList';

export function GroupMemberListPage(props) {
  useInjectReducer({ key: 'userList', reducer });
  useInjectSaga({ key: 'userList', saga });

  const rs = new RouteService(useContext);

  useEffect(() => {
    return () => {
      props.userListUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <GroupMemberList />
    </React.Fragment>
  );
}

GroupMemberListPage.propTypes = {
  userListUnmount: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
});

const mapDispatchToProps = {
  userListUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupMemberListPage);
