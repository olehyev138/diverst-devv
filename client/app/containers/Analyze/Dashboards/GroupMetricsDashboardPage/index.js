import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectReducer } from 'utils/injectReducer';
import { useInjectSaga } from 'utils/injectSaga';

import reducer from 'containers/Analyze/reducer';
import groupReducer from 'containers/Group/reducer';
import groupSaga from 'containers/Group/saga';

import { metricsUnmount } from 'containers/Analyze/actions';
import { getGroupsBegin } from 'containers/Group/actions';
import { selectPaginatedSelectGroups } from 'containers/Group/selectors';

import { Grid, Card, CardContent } from '@material-ui/core';
import GroupPopulationGraphPage from 'containers/Analyze/Graphs/GroupPopulationGraphPage';
import GrowthOfGroupsGraphPage from 'containers/Analyze/Graphs/GrowthOfGroupsGraphPage';

import GroupScopeSelect from 'components/Analyze/Shared/GroupScopeSelect';

export function GroupMetricsDashboardPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectReducer({ key: 'groups', reducer: groupReducer });
  useInjectSaga({ key: 'groups', saga: groupSaga });

  const [params, setParams] = useState({
    scoped_by_models: []
  });

  const updateScope = (scope) => {
    const newParams = { scoped_by_models: scope.groups ? scope.groups.map(g => g.value) : [] };

    setParams(newParams);
  };

  useEffect(() => () => {
  }, []);

  return (
    <Grid container spacing={3}>
      <Grid item xs={12}>
        <GroupScopeSelect
          groups={props.groups}
          getGroupsBegin={props.getGroupsBegin}
          updateScope={updateScope}
        />
      </Grid>
      <Grid item xs={12}>
        <GroupPopulationGraphPage dashboardParams={params} />
      </Grid>

      <Grid item xs={12}>
        <GrowthOfGroupsGraphPage dashboardParams={params} />
      </Grid>
    </Grid>
  );
}

GroupMetricsDashboardPage.propTypes = {
  groups: PropTypes.array,
  getGroupsBegin: PropTypes.func,
  metricsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  groups: selectPaginatedSelectGroups()
});

const mapDispatchToProps = {
  getGroupsBegin,
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GroupMetricsDashboardPage);
