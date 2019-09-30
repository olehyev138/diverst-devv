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
  getViewsPerNewsLinkBegin, metricsUnmount
} from 'containers/Analyze/actions';

import {
  selectViewsPerNewsLink
} from 'containers/Analyze/selectors';

// helpers
import {
  getUpdateRange, getHandleDrilldown, formatBarGraphData
} from 'utils/metricsHelpers';

import ViewsPerNewsLinkGraph from 'components/Analyze/Graphs/ViewsPerNewsLinkGraph';

export function ViewsPerNewsLinkGraphPage(props) {
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
    props.getViewsPerNewsLinkBegin(params);
  }, [params]);

  return (
    <React.Fragment>
      <ViewsPerNewsLinkGraph
        data={currentData}
        updateRange={getUpdateRange([params, setParams])}
        handleDrilldown={getHandleDrilldown([props.data, setCurrentData], [isDrilldown, setIsDrilldown])}
        isDrilldown={isDrilldown}
      />
    </React.Fragment>
  );
}

ViewsPerNewsLinkGraphPage.propTypes = {
  data: PropTypes.array,
  dashboardParams: PropTypes.object,
  getViewsPerNewsLinkBegin: PropTypes.func,
  metricsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  data: selectViewsPerNewsLink()
});

const mapDispatchToProps = {
  getViewsPerNewsLinkBegin,
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(ViewsPerNewsLinkGraphPage);