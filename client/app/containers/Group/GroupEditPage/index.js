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

import { selectFormGroup, selectGroupIsCommitting, selectPaginatedSelectGroups, selectGroupIsFormLoading } from 'containers/Group/selectors';
import {
  getGroupBegin, getGroupsBegin,
  updateGroupBegin, groupFormUnmount,
  getGroupsSuccess,
} from 'containers/Group/actions';

import GroupForm from 'components/Group/GroupForm';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Group/messages';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import { GroupCreatePage } from 'containers/Group/GroupCreatePage';

export function GroupEditPage(props) {
  useInjectReducer({ key: 'groups', reducer });
  useInjectSaga({ key: 'groups', saga });
  const { intl } = props;
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
        edit
        groupAction={props.updateGroupBegin}
        getGroupsBegin={props.getGroupsBegin}
        selectGroups={props.groups}
        group={props.group}
        buttonText={intl.formatMessage(messages.update)}
        isCommitting={props.isCommitting}
        isFormLoading={props.isFormLoading}
        getGroupsSuccess={props.getGroupsSuccess}
      />
    </React.Fragment>
  );
}

GroupEditPage.propTypes = {
  intl: intlShape,
  group: PropTypes.object,
  groups: PropTypes.array,
  getGroupBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  updateGroupBegin: PropTypes.func,
  groupFormUnmount: PropTypes.func,
  getGroupsSuccess: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  group: selectFormGroup(),
  groups: selectPaginatedSelectGroups(),
  isCommitting: selectGroupIsCommitting(),
  isFormLoading: selectGroupIsFormLoading(),
});

const mapDispatchToProps = {
  getGroupBegin,
  getGroupsBegin,
  updateGroupBegin,
  groupFormUnmount,
  getGroupsSuccess,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  injectIntl,
  withConnect,
  memo,
)(Conditional(
  GroupCreatePage,
  ['group.permissions.update?', 'isFormLoading'],
  (props, rs) => ROUTES.admin.manage.groups.index.path(),
  'group.editPage'
));
