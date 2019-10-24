import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Group/saga';
import reducer from 'containers/Group/reducer';

import RouteService from 'utils/routeHelpers';

import { selectFormGroup, selectGroupIsCommitting, selectPaginatedSelectGroups } from 'containers/Group/selectors';
import {
  getGroupBegin, getGroupsBegin,
  updateGroupBegin, groupFormUnmount
} from 'containers/Group/actions';

import GroupForm from 'components/Group/GroupForm';

export function GroupEditPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const rs = new RouteService(useContext);

  useEffect(() => {
    props.getGroupBegin({ id: rs.params('group_id') });

    return () => {
      props.groupFormUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <GroupForm
        groupAction={props.updateGroupBegin}
        getGroupsBegin={props.getGroupsBegin}
        selectGroups={props.groups}
        group={props.group}
        buttonText='Update'
        isCommitting={props.isCommitting}
      />
    </React.Fragment>
  );
}

GroupEditPage.propTypes = {
  group: PropTypes.object,
  groups: PropTypes.array,
  getGroupBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  updateGroupBegin: PropTypes.func,
  groupFormUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  group: selectFormGroup(),
  groups: selectPaginatedSelectGroups(),
  isCommitting: selectGroupIsCommitting(),
});

const mapDispatchToProps = {
  getGroupBegin,
  getGroupsBegin,
  updateGroupBegin,
  groupFormUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupEditPage);
