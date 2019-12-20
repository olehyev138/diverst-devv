import React, { memo, useContext, useEffect } from 'react';
import PropTypes from 'prop-types';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect';
import { compose } from 'redux';

import KPILayout from 'containers/Layouts/GroupPlanLayout/KPILayout';
import {
  getFieldsBegin,
  fieldsUnmount
} from '../actions';
import {
  selectPaginatedFields,
  selectFieldsTotal,
  selectHasChangedField,
  selectIsFetchingFields,
  selectIsCommittingField,
} from '../selectors';

import Kpi from 'components/Group/GroupPlan/KpiMetrics';
import RouteService from 'utils/routeHelpers';

import { useInjectReducer } from 'utils/injectReducer';
import reducer from '../reducer';
import { useInjectSaga } from 'utils/injectSaga';
import saga from '../saga';

export function KpiPage(props) {
  useInjectReducer({ key: 'kpi', reducer });
  useInjectSaga({ key: 'kpi', saga });
  const rs = new RouteService(useContext);
  const links = {};

  useEffect(() => {
    const groupId = rs.params('group_id');
    props.getFieldsBegin({ group_id: groupId });

    return () => props.fieldsUnmount();
  }, []);

  return (
    <Kpi />
  );
}

KpiPage.propTypes = {
  currentGroup: PropTypes.shape({
    id: PropTypes.number,
  }),

  getFieldsBegin: PropTypes.func,
  fieldsUnmount: PropTypes.func,

  fields: PropTypes.array,
  fieldsTotal: PropTypes.number,
  hasChanged: PropTypes.bool,
  isLoading: PropTypes.bool,
  isCommitting: PropTypes.bool,
};

const mapStateToProps = createStructuredSelector({
  fields: selectPaginatedFields(),
  fieldsTotal: selectFieldsTotal(),
  hasChanged: selectHasChangedField(),
  isLoading: selectIsFetchingFields(),
  isCommitting: selectIsCommittingField(),
});

const mapDispatchToProps = {
  getFieldsBegin,
  fieldsUnmount,
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(KpiPage);
