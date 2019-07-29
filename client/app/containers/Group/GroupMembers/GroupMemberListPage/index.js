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

import { getMembersBegin, groupMembersUnmount } from 'containers/Group/GroupMembers/actions';
import { selectPaginatedMembers, selectMemberTotal } from 'containers/Group/GroupMembers/selectors';

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

    props.getMembersBegin(params);

    return () => {
      props.groupMembersUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <GroupMemberList
        memberList={props.memberList}
        memberTotal={props.memberTotal}
      />
    </React.Fragment>
  );
}

GroupMemberListPage.propTypes = {
  getMembersBegin: PropTypes.func,
  groupMembersUnmount: PropTypes.func,
  memberList: PropTypes.object,
  memberTotal: PropTypes.number
};

const mapStateToProps = createStructuredSelector({
  memberList: selectPaginatedMembers(),
  memberTotal: selectMemberTotal()
});

const mapDispatchToProps = {
  getMembersBegin,
  groupMembersUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupMemberListPage);
