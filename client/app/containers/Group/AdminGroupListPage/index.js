/**
 *
 * AdminGroupListPage
 *
 */

import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import { selectPaginatedGroups, selectGroupTotal, selectGroup } from 'containers/Group/selectors';
import { getGroupsBegin, groupListUnmount, deleteGroupBegin } from 'containers/Group/actions';
import reducer from 'containers/Group/reducer';

import saga from 'containers/Group/saga';

import GroupList from 'components/Group/AdminGroupList';

export function AdminGroupListPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  useEffect(() => {
    props.getGroupsBegin();

    return () => {
      props.groupListUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <GroupList
        groups={props.groups}
        groupTotal={props.groupTotal}
        deleteGroupBegin={props.deleteGroupBegin}
      />
    </React.Fragment>
  );
}

AdminGroupListPage.propTypes = {
  getGroupsBegin: PropTypes.func.isRequired,
  groupListUnmount: PropTypes.func.isRequired,
  groups: PropTypes.object,
  groupTotal: PropTypes.number,
  deleteGroupBegin: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedGroups(),
  groupTotal: selectGroupTotal(),
});

function mapDispatchToProps(dispatch) {
  return {
    getGroupsBegin: payload => dispatch(getGroupsBegin(payload)),
    groupListUnmount: () => dispatch(groupListUnmount()),
    deleteGroupBegin: payload => dispatch(deleteGroupBegin(payload))
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(AdminGroupListPage);
