import React, { memo, useEffect, useContext, useState, useRef } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import dig from 'object-dig';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Analyze/reducer';
import saga from 'containers/Analyze/saga';

import { getGrowthOfResourcesBegin, metricsUnmount } from 'containers/Analyze/actions';
import { selectGrowthOfResources } from 'containers/Analyze/selectors';

// helpers
import { getUpdateRange } from 'utils/metricsHelpers';

import GrowthOfResourcesGraph from 'components/Analyze/Graphs/GrowthOfResourcesGraph';

export function GrowthOfResourcesGraphPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  const data = (dig(props.data, 'series') || undefined);
  const [currentData, setCurrentData] = useState([]);
  const isInitialRender = useRef(true);

  const [params, setParams] = useState({
    date_range: {
      from_date: '',
      to_date: ''
    },
    scoped_by_models: props.dashboardParams.scoped_by_models
  });

  useEffect(() => {
    setCurrentData(props.data);
  }, [props.data]);

  useEffect(() => {
    if (isInitialRender.current)
      isInitialRender.current = false;
    else
      setParams({ ...params, scoped_by_models: props.dashboardParams.scoped_by_models });
  }, [props.dashboardParams]);

  useEffect(() => {
    props.getGrowthOfResourcesBegin(params);
  }, [params]);

  return (
    <React.Fragment>
      <GrowthOfResourcesGraph
        data={data}
        updateRange={getUpdateRange([params, setParams])}
      />
    </React.Fragment>
  );
}

GrowthOfResourcesGraphPage.propTypes = {
  data: PropTypes.object,
  dashboardParams: PropTypes.object,
  getGrowthOfResourcesBegin: PropTypes.func,
  metricsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  data: selectGrowthOfResources()
});

const mapDispatchToProps = {
  getGrowthOfResourcesBegin,
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GrowthOfResourcesGraphPage);
