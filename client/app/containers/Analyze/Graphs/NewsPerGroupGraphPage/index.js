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
  getNewsPerGroupBegin, metricsUnmount
} from 'containers/Analyze/actions';

import {
  selectNewsPerGroup
} from 'containers/Analyze/selectors';

// helpers
import { filterData } from 'utils/metricsHelpers';

import NewsPerGroupGraph from 'components/Analyze/Graphs/NewsPerGroupGraph';

export function NewsPerGroupGraphPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  /**
   * News per group bar graph
   *  - implements no graph specific filtering
   *  - accepts dashboard filters
   */

  const [currentData, setCurrentData] = useState([]);

  useEffect(() => {
    setCurrentData(filterData(props.data, props.dashboardFilters).slice(0, 10));
  }, [props.data, props.dashboardFilters]);

  useEffect(() => {
    props.getNewsPerGroupBegin();
  }, []);

  return (
    <React.Fragment>
      <NewsPerGroupGraph
        data={currentData}
      />
    </React.Fragment>
  );
}

NewsPerGroupGraphPage.propTypes = {
  data: PropTypes.array,
  dashboardFilters: PropTypes.array,
  getNewsPerGroupBegin: PropTypes.func,
  metricsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  data: selectNewsPerGroup()
});

const mapDispatchToProps = {
  getNewsPerGroupBegin,
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(NewsPerGroupGraphPage);
