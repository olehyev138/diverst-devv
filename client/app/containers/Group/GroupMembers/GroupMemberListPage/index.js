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
import { selectPaginatedUsers } from 'containers/Group/GroupMembers/selectors';
import RouteService from 'utils/routeHelpers';

import GroupMemberList from 'components/Group/GroupMembers/GroupMemberList';

export function GroupMemberListPage(props) {
  useInjectReducer({ key: 'userList', reducer });
  useInjectSaga({ key: 'userList', saga });

  const rs = new RouteService(useContext);
  const links = {
  };

  useEffect(() => {
    const params = { group_id: 1 };

    props.getUsersBegin(params);

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
  getUsersBegin: PropTypes.func,
  userListUnmount: PropTypes.func,
};

const mapStateToProps = createStructuredSelector({
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
