import React, { memo, useEffect, useContext, useState, useRef } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { connect } from 'react-redux';
import { createStructuredSelector } from 'reselect/lib';

import { useInjectSaga } from 'utils/injectSaga';
import { useInjectReducer } from 'utils/injectReducer';

import reducer from 'containers/Analyze/reducer';
import saga from 'containers/Analyze/saga';

import { getGrowthOfGroupsBegin, metricsUnmount } from 'containers/Analyze/actions';
import { selectGrowthOfGroups } from 'containers/Analyze/selectors';

// helpers
import { filterData, getUpdateDateFilters } from 'utils/metricsHelpers';

import GrowthOfGroupsGraph from 'components/Analyze/Graphs/GrowthOfGroupsGraph';

const DEFAULT_LIMIT = 10;

/**
 * *Expensive* function to limit data to 10 (default) top groups by total members
 */
function limitData(data) {
  // get uniq list of data by name, sort by total desc & get first 10
  const uniq = data
    .filter((obj, i, self) => self.map(o => o.name).indexOf(obj.name) === i)
    .sort((a, b) => b.total - a.total)
    .slice(0, DEFAULT_LIMIT);

  // filter data by top groups
  return data.filter(i => uniq.filter(f => f.name === i.name).length !== 0);
}

export function GrowthOfGroupsGraphPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  /**
   * Growth of Groups line graph
   *  - implements graph specific date filtering
   *  - accepts dashboard filters
   */

  /* Sets state filters hash,
   *  - updated via date range callback or when dashboard filters change
   *  - use hash for easy updating
   */
  const [filters, setFilters] = useState({});
  const [currentData, setCurrentData] = useState([]);

  useEffect(() => {
    props.getGrowthOfGroupsBegin();
  }, []);

  // Set data in state & filter it with given filters when data or filters change
  useEffect(() => {
    const data = limitData(filterData(props.data, [].concat(...Object.values(filters))));

    // Extract values from filters hash & flatten to single array of filter objects
    setCurrentData(data);
  }, [props.data, filters]);

  // Update filters when dashboard filters change
  useEffect(() => {
    /* eslint-disable no-return-assign */
    setFilters({ ...filters, dashboardFilters: props.dashboardFilters });
  }, [props.dashboardFilters]);

  return (
    <React.Fragment>
      <GrowthOfGroupsGraph
        data={currentData}
        updateDateFilters={getUpdateDateFilters(filters, setFilters)}
      />
    </React.Fragment>
  );
}

GrowthOfGroupsGraphPage.propTypes = {
  data: PropTypes.array,
  dashboardFilters: PropTypes.array,
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
