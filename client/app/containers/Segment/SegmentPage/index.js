import React, { memo, useEffect } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';
import { useParams } from 'react-router-dom';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import saga from 'containers/Segment/saga';
import reducer from 'containers/Segment/reducer';
import groupSaga from 'containers/Group/saga';
import groupReducer from 'containers/Group/reducer';
import fieldsSaga from 'containers/GlobalSettings/Field/saga';
import fieldReducer from 'containers/Shared/Field/reducer';

import { getGroupsBegin } from 'containers/Group/actions';
import { getFieldsBegin } from 'containers/Shared/Field/actions';
import {
  getSegmentBegin, createSegmentBegin, getSegmentMembersBegin,
  updateSegmentBegin, segmentUnmount
} from 'containers/Segment/actions';
import { selectCustomText, selectEnterprise, selectPermissions } from '../../Shared/App/selectors';

import { selectIsCommitting, selectSegmentWithRules, selectIsFormLoading } from 'containers/Segment/selectors';
import { selectPaginatedSelectGroups } from 'containers/Group/selectors';
import {
  selectPaginatedOptionsSelectFields, selectPaginatedSelectFields
} from 'containers/Shared/Field/selectors';

import { Divider, Box } from '@material-ui/core';

import SegmentForm from 'components/Segment/SegmentForm';
import SegmentMemberListPage from 'containers/Segment/SegmentMemberListPage';


import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Segment/messages';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';
import permissionMessages from 'containers/Shared/Permissions/messages';

export function SegmentPage(props) {
  useInjectReducer({ key: 'segments', reducer });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectReducer({ key: 'fields', reducer: fieldReducer });
  useInjectSaga({ key: 'segments', saga });
  useInjectSaga({ key: 'groups', saga: groupSaga });
  useInjectSaga({ key: 'fields', saga: fieldsSaga });
  const { intl } = props;

  const { segment_id: segmentId } = useParams();

  const params = {
    segment_id: segmentId, count: 5, page: 0, order: 'asc'
  };

  useEffect(() => {
    if (segmentId)
      props.getSegmentBegin({ id: segmentId });

    return () => {
      props.segmentUnmount();
    };
  }, []);

  return (
    <React.Fragment>
      <SegmentForm
        edit={props.edit}
        segmentAction={segmentId ? props.updateSegmentBegin : props.createSegmentBegin}
        segment={props.segment}
        ruleProps={{
          getGroupsBegin: props.getGroupsBegin,
          getFieldsBegin: props.getFieldsBegin,
          groups: props.groups,
          selectFields: props.selectFields,
          fields: props.fields
        }}
        buttonText={segmentId ? intl.formatMessage(messages.update, props.customTexts) : intl.formatMessage(messages.create, props.customTexts)}
        isCommitting={props.isCommitting}
        isFormLoading={props.edit ? props.isFormLoading : undefined}
        currentEnterprise={props.currentEnterprise}
        customTexts={props.customTexts}
        intl={props.intl}
      />
      <Box mb={4} />
      <Divider />
      <Box mb={4} />
      <SegmentMemberListPage />
    </React.Fragment>
  );
}

SegmentPage.propTypes = {
  intl: intlShape.isRequired,
  edit: PropTypes.bool,
  segment: PropTypes.object,
  rules: PropTypes.object,
  getSegmentBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  getFieldsBegin: PropTypes.func,
  groups: PropTypes.array,
  selectFields: PropTypes.array,
  fields: PropTypes.array,
  createSegmentBegin: PropTypes.func,
  updateSegmentBegin: PropTypes.func,
  segmentUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  currentEnterprise: PropTypes.shape({
    id: PropTypes.number,
  }),
  customTexts: PropTypes.object,
};

const mapStateToProps = createStructuredSelector({
  segment: selectSegmentWithRules(),
  groups: selectPaginatedSelectGroups(),
  selectFields: selectPaginatedSelectFields(),
  fields: selectPaginatedOptionsSelectFields(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
  currentEnterprise: selectEnterprise(),
  permissions: selectPermissions(),
  customTexts: selectCustomText(),
});

const mapDispatchToProps = {
  getSegmentBegin,
  createSegmentBegin,
  updateSegmentBegin,
  segmentUnmount,
  getGroupsBegin,
  getFieldsBegin,
  getSegmentMembersBegin,
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
  SegmentPage,
  ['edit', 'permissions.segments_create', 'segment.permissions.update?', 'isFormLoading'],
  (props, params) => props.permissions.adminPath || ROUTES.user.home.path(),
  permissionMessages.segment.showPage,
  true,
  a => a[3] || (a[0] ? a[2] : a[1])
));
