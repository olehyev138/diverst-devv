import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import dig from 'object-dig';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Analyze/reducer';
import saga from 'containers/Analyze/saga';

import {
  getGrowthOfGroupsBegin, metricsUnmount
} from 'containers/Analyze/actions';

import {
  selectGrowthOfGroups
} from 'containers/Analyze/selectors';

import RouteService from 'utils/routeHelpers';

import GrowthOfGroupsGraph from 'components/Analyze/Graphs/GrowthOfGroupsGraph';

export function GrowthOfGroupsGraphPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  const data = (dig(props.data, 'series') || undefined);

  const [params, setParams] = useState({
    date_range: {
      from_date: '',
      to_date: ''
    },
    scoped_by_models: []
  });

  const updateRange = (range) => {
    const newParams = { ...params, date_range: range };

    props.getGrowthOfGroupsBegin(newParams);
    setParams(newParams);
  };

  if (params.scoped_by_models !== props.dashboardParams.scoped_by_models)
    setParams({ ...params, scoped_by_models: props.dashboardParams.scoped_by_models });

  useEffect(() => {
    props.getGrowthOfGroupsBegin(params);
  }, [params]);

  return (
    <React.Fragment>
      <GrowthOfGroupsGraph
        data={data ? data.slice(0, 15) : [{ key: 'dummy', values: [{ x: 0, y: 0 }] }]}
        updateRange={updateRange}
      />
    </React.Fragment>
  );
}

GrowthOfGroupsGraphPage.propTypes = {
  data: PropTypes.object,
  dashboardParams: PropTypes.object,
  getGrowthOfGroupsBegin: PropTypes.func,
  metricsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  data: selectGrowthOfGroups()
});

const mapDispatchToProps = {
  getGrowthOfGroupsBegin,
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GrowthOfGroupsGraphPage);
