import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

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

import { selectIsCommitting, selectSegmentWithRules, selectIsFormLoading } from 'containers/Segment/selectors';
import { selectPaginatedSelectGroups } from 'containers/Group/selectors';
import {
  selectPaginatedFields, selectPaginatedSelectFields
} from 'containers/Shared/Field/selectors';

import { Divider, Box } from '@material-ui/core';

import RouteService from 'utils/routeHelpers';

import SegmentForm from 'components/Segment/SegmentForm';
import SegmentMemberListPage from 'containers/Segment/SegmentMemberListPage';
import { selectEnterprise, selectPermissions } from 'containers/Shared/App/selectors';

import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Segment/messages';
import Conditional from 'components/Compositions/Conditional';
import { ROUTES } from 'containers/Shared/Routes/constants';

export function SegmentPage(props) {
  useInjectReducer({ key: 'segments', reducer });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectReducer({ key: 'fields', reducer: fieldReducer });
  useInjectSaga({ key: 'segments', saga });
  useInjectSaga({ key: 'groups', saga: groupSaga });
  useInjectSaga({ key: 'fields', saga: fieldsSaga });
  const { intl } = props;
  const rs = new RouteService(useContext);
  const segmentIds = rs.params('segment_id');
  const segmentId = segmentIds ? segmentIds[0] : null;

  const params = {
    segment_id: segmentId, count: 5, page: 0, order: 'asc'
  };

  useEffect(() => {
    if (segmentId)
      props.getSegmentBegin({ id: rs.params('segment_id') });

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
        buttonText={segmentId ? intl.formatMessage(messages.update) : intl.formatMessage(messages.create)}
        isCommitting={props.isCommitting}
        isFormLoading={props.edit ? props.isFormLoading : undefined}
        currentEnterprise={props.currentEnterprise}
      />
      <Box mb={4} />
      <Divider />
      <Box mb={4} />
      <SegmentMemberListPage />
    </React.Fragment>
  );
}

SegmentPage.propTypes = {
  intl: intlShape,
  edit: PropTypes.bool,
  segment: PropTypes.object,
  rules: PropTypes.object,
  getSegmentBegin: PropTypes.func,
  getGroupsBegin: PropTypes.func,
  getFieldsBegin: PropTypes.func,
  groups: PropTypes.array,
  selectFields: PropTypes.array,
  fields: PropTypes.object,
  createSegmentBegin: PropTypes.func,
  updateSegmentBegin: PropTypes.func,
  segmentUnmount: PropTypes.func,
  isCommitting: PropTypes.bool,
  isFormLoading: PropTypes.bool,
  currentEnterprise: PropTypes.shape({
    id: PropTypes.number,
  })
};

const mapStateToProps = createStructuredSelector({
  segment: selectSegmentWithRules(),
  groups: selectPaginatedSelectGroups(),
  selectFields: selectPaginatedSelectFields(),
  fields: selectPaginatedFields(),
  isCommitting: selectIsCommitting(),
  isFormLoading: selectIsFormLoading(),
  currentEnterprise: selectEnterprise(),
  permissions: selectPermissions(),
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
  (props, rs) => props.permissions.adminPath || ROUTES.user.home.path(),
  'segment.showPage',
  true,
  a => a[3] || (a[0] ? a[2] : a[1])
));
