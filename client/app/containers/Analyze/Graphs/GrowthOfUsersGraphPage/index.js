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

import { getGrowthOfUsersBegin, metricsUnmount } from 'containers/Analyze/actions';
import { selectGrowthOfUsers } from 'containers/Analyze/selectors';

// helpers
import { getUpdateRange } from 'utils/metricsHelpers';

import GrowthOfUsersGraph from 'components/Analyze/Graphs/GrowthOfUsersGraph';

export function GrowthOfUsersGraphPage(props) {
  useInjectReducer({ key: 'metrics', reducer });
  useInjectSaga({ key: 'metrics', saga });

  const data = (dig(props.data, 'series') || undefined);
  const [currentData, setCurrentData] = useState([]);

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
    props.getGrowthOfUsersBegin(params);
  }, [params]);

  return (
    <React.Fragment>
      <GrowthOfUsersGraph
        data={data}
        updateRange={getUpdateRange([params, setParams])}
      />
    </React.Fragment>
  );
}

GrowthOfUsersGraphPage.propTypes = {
  data: PropTypes.object,
  getGrowthOfUsersBegin: PropTypes.func,
  dashboardParams: PropTypes.object,
  metricsUnmount: PropTypes.func
};

const mapStateToProps = createStructuredSelector({
  data: selectGrowthOfUsers()
});

const mapDispatchToProps = {
  getGrowthOfUsersBegin,
  metricsUnmount
};

const withConnect = connect(
  mapStateToProps,
  mapDispatchToProps,
);

export default compose(
  withConnect,
  memo,
)(GrowthOfUsersGraphPage);
