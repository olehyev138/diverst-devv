import React, { memo, useEffect, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';
import reducer from 'containers/Group/reducer';
import saga from 'containers/Group/saga';

import { createGroupBegin, getGroupsBegin, groupFormUnmount, getGroupsSuccess } from 'containers/Group/actions';
import { selectPaginatedSelectGroups, selectGroupTotal, selectGroupIsCommitting } from 'containers/Group/selectors';

import GroupForm from 'components/Group/GroupForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/messages';
export function GroupCreatePage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });
  const { intl } = props;
  useEffect(() => () => props.groupFormUnmount(), []);

  return (
    <GroupForm
      groupAction={props.createGroupBegin}
      buttonText={intl.formatMessage(messages.create)}
      getGroupsBegin={props.getGroupsBegin}
      selectGroups={props.groups}
      isCommitting={props.isCommitting}
      getGroupsSuccess={props.getGroupsSuccess}
    />
  );
}

GroupCreatePage.propTypes = {
  intl: intlShape,
  createGroupBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  groupFormUnmount: PropTypes.func,
  getGroupsSuccess: PropTypes.func,
  groups: PropTypes.array,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedSelectGroups(),
  isCommitting: selectGroupIsCommitting(),
});

const mapDispatchToProps = {
  createGroupBegin,
  getGroupsBegin,
  getGroupsSuccess,
  groupFormUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  injectIntl,
  withConnect,
  memo,
)(GroupCreatePage);
