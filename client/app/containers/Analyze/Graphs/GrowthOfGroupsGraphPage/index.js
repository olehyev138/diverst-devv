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

  const params = {
    date_range: { from_date: '1m' }
  };

  useEffect(() => {
    props.getGrowthOfGroupsBegin();
  }, []);

  return (
    <React.Fragment>
      <GrowthOfGroupsGraph
        data={data ? data.slice(0, 15) : undefined}
      />
    </React.Fragment>
  );
}

GrowthOfGroupsGraphPage.propTypes = {
  data: PropTypes.object,
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
