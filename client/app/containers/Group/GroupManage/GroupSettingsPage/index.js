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
import {
  updateGroupSettingsBegin, groupFormUnmount
} from 'containers/Group/actions';

import GroupSettings from 'components/Group/GroupManage/GroupSettings';

export function GroupSettingsPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  const rs = new RouteService(useContext);
  useEffect(() => () => props.groupFormUnmount());

  return (
    <React.Fragment>
      <GroupSettings
        groupAction={props.updateGroupSettingsBegin}
        group={props.currentGroup}
      />
    </React.Fragment>
  );
}

GroupSettingsPage.propTypes = {
  currentGroup: PropTypes.object,
  updateGroupSettingsBegin: PropTypes.func,
  groupFormUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
});

const mapDispatchToProps = {
  updateGroupSettingsBegin,
  groupFormUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupSettingsPage);
