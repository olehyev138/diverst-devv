import React, {
  memo, useEffect, useContext
} from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/GroupMembers/reducer';
import saga from 'containers/Group/GroupMembers/saga';

import { getUsersBegin, userListUnmount } from 'containers/Group/GroupMembers/actions';
import { selectPaginatedUsers, selectUserTotal } from 'containers/Group/GroupMembers/selectors';

import RouteService from 'utils/routeHelpers';
import { ROUTES } from 'containers/Shared/Routes/constants';

import GroupMemberList from 'components/Group/GroupMembers/GroupMemberList';

export function GroupMemberListPage(props) {
  useInjectReducer({ key: 'members', reducer });
  useInjectSaga({ key: 'members', saga });

  const rs = new RouteService(useContext);
  const groupId = rs.params('group_id')[0];
  const links = {
  };

  useEffect(() => {
    const params = { group_id: groupId };

    props.getUsersBegin(params);

    return () => {
      props.userListUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <GroupMemberList
        userList={props.userList}
        userTotal={props.userTotal}
        getUsersBegin={props.getUsersBegin}
      />
    </React.Fragment>
  );
}

GroupMemberListPage.propTypes = {
  getUsersBegin: PropTypes.func,
  userListUnmount: PropTypes.func,
  userList: PropTypes.object,
  userTotal: PropTypes.number
};

const mapStateToProps = createStructuredSelector({
  userList: selectPaginatedUsers(),
  userTotal: selectUserTotal()
});

const mapDispatchToProps = {
  getUsersBegin,
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
