import React, { memo, useEffect, useRef, useState } from 'react';
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
  getViewsPerGroupBegin, metricsUnmount
} from 'containers/Analyze/actions';

import {
  selectViewsPerGroup
} from 'containers/Analyze/selectors';

// helpers
import {
  getUpdateRange, getHandleDrilldown, formatBarGraphData
} from 'utils/metricsHelpers';

import ViewsPerGroupGraph from 'components/Analyze/Graphs/ViewsPerGroupGraph';

export function ViewsPerGroupGraphPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  const [currentData, setCurrentData] = useState([]);
  const [isDrilldown, setIsDrilldown] = useState(false);
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
    props.getViewsPerGroupBegin(params);
  }, [params]);

  return (
    <React.Fragment>
      <ViewsPerGroupGraph
        data={currentData}
        updateRange={getUpdateRange([params, setParams])}
        handleDrilldown={getHandleDrilldown([props.data, setCurrentData], [isDrilldown, setIsDrilldown])}
        isDrilldown={isDrilldown}
      />
    </React.Fragment>
  );
}

ViewsPerGroupGraphPage.propTypes = {
  data: PropTypes.array,
  dashboardParams: PropTypes.object,
  getViewsPerGroupBegin: PropTypes.func,
  metricsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  data: selectViewsPerGroup()
});

const mapDispatchToProps = {
  getViewsPerGroupBegin,
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(ViewsPerGroupGraphPage);
