import React, { memo, useEffect, useRef, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

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
  filterData
} from 'utils/metricsHelpers';

import ViewsPerFolderGraph from 'components/Analyze/Graphs/ViewsPerFolderGraph';

export function ViewsPerFolderGraphPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  /**
   * Views per Folder coloured bar graph
   *  - implements no graph specific filtering
   *  - accepts dashboard filters
   */

  const [currentData, setCurrentData] = useState([]);

  useEffect(() => {
    setCurrentData(filterData(props.data, props.dashboardFilters).slice(0, 10));
  }, [props.data, props.dashboardFilters]);

  useEffect(() => {
    props.getViewsPerFolderBegin();
  }, []);

  return (
    <React.Fragment>
      <ViewsPerFolderGraph
        data={currentData}
      />
    </React.Fragment>
  );
}

ViewsPerFolderGraphPage.propTypes = {
  data: PropTypes.array,
  dashboardFilters: PropTypes.array,
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
