import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { compose } from 'redux';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import { selectFormGroup, selectPaginatedSelectGroups } from 'containers/Group/selectors';

import RouteService from 'utils/routeHelpers';

import {
  getGroupBegin, getGroupsBegin,
  updateGroupBegin, groupFormUnmount
} from 'containers/Group/actions';

import saga from 'containers/Group/saga';
import GroupForm from 'components/Group/GroupForm';

export function GroupEditPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const rs = new RouteService(useContext);

  useEffect(() => {
    props.getGroupBegin({ id: rs.params('id') });

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
  groupFormUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  group: selectFormGroup(),
  groups: selectPaginatedSelectGroups()
});

function mapDispatchToProps(dispatch) {
  return {
    getGroupBegin: payload => dispatch(getGroupBegin(payload)),
    getGroupsBegin: payload => dispatch(getGroupsBegin(payload)),
    updateGroupBegin: payload => dispatch(updateGroupBegin(payload)),
    groupFormUnmount: () => dispatch(groupFormUnmount())
  };
}

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupEditPage);
