import React, { memo, useEffect, useContext } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import saga from 'containers/Group/saga';
import reducer from 'containers/Group/reducer';

import {
  updateGroupSettingsBegin
} from 'containers/Group/actions';

import { selectGroupIsCommitting } from 'containers/Group/selectors';

import GroupManageLayout from 'containers/Layouts/GroupManageLayout';
import GroupSettings from 'components/Group/GroupManage/GroupSettings';

export function GroupSettingsPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });

  return (
    <React.Fragment>
      <GroupManageLayout
        component={() => (
          <GroupSettings
            groupAction={props.updateGroupSettingsBegin}
            group={props.currentGroup}
            isCommitting={props.isCommitting}
          />
        )}
        {...props}
      />
    </React.Fragment>
  );
}

GroupSettingsPage.propTypes = {
  currentGroup: PropTypes.object,
  updateGroupSettingsBegin: PropTypes.func,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  isCommitting: selectGroupIsCommitting(),
});

const mapDispatchToProps = {
  updateGroupSettingsBegin,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupSettingsPage);
