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
  getViewsPerFolderBegin, metricsUnmount
} from 'containers/Analyze/actions';

import {
  selectViewsPerFolder
} from 'containers/Analyze/selectors';

// helpers
import {
  getUpdateRange, getHandleDrilldown, formatBarGraphData
} from 'utils/metricsHelpers';

import ViewsPerFolderGraph from 'components/Analyze/Graphs/ViewsPerFolderGraph';

export function ViewsPerFolderGraphPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  const [currentData, setCurrentData] = useState([]);
  const [isDrilldown, setIsDrilldown] = useState(false);
  const isInitalRender = useRef(true);

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
    if (isInitalRender.current)
      isInitalRender.current = false;
    else
      setParams({ ...params, scoped_by_models: props.dashboardParams.scoped_by_models });
  }, [props.dashboardParams]);

  useEffect(() => {
    props.getViewsPerFolderBegin(params);
  }, [params]);

  return (
    <React.Fragment>
      <ViewsPerFolderGraph
        data={currentData}
        updateRange={getUpdateRange([params, setParams])}
        handleDrilldown={getHandleDrilldown([props.data, setCurrentData], [isDrilldown, setIsDrilldown])}
        isDrilldown={isDrilldown}
      />
    </React.Fragment>
  );
}

ViewsPerFolderGraphPage.propTypes = {
  data: PropTypes.array,
  dashboardParams: PropTypes.object,
  getViewsPerFolderBegin: PropTypes.func,
  metricsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  data: selectViewsPerFolder()
});

const mapDispatchToProps = {
  getViewsPerFolderBegin,
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(ViewsPerFolderGraphPage);
