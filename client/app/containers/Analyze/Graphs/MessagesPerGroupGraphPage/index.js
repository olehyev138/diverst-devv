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
  getMessagesPerGroupBegin, metricsUnmount
} from 'containers/Analyze/actions';

import {
  selectMessagesPerGroup
} from 'containers/Analyze/selectors';

// helpers
import {
  getUpdateRange, getHandleDrilldown
} from 'utils/metricsHelpers';

import MessagesPerGroupGraph from 'components/Analyze/Graphs/MessagesPerGroupGraph';

export function MessagesPerGroupGraphPage(props) {
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
    props.getMessagesPerGroupBegin(params);
  }, [params]);

  return (
    <React.Fragment>
      <MessagesPerGroupGraph
        data={currentData}
        updateRange={getUpdateRange([params, setParams])}
        handleDrilldown={getHandleDrilldown([props.data, setCurrentData], [isDrilldown, setIsDrilldown])}
        isDrilldown={isDrilldown}
      />
    </React.Fragment>
  );
}

MessagesPerGroupGraphPage.propTypes = {
  data: PropTypes.array,
  dashboardParams: PropTypes.object,
  getMessagesPerGroupBegin: PropTypes.func,
  metricsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  data: selectMessagesPerGroup()
});

const mapDispatchToProps = {
  getMessagesPerGroupBegin,
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(MessagesPerGroupGraphPage);
