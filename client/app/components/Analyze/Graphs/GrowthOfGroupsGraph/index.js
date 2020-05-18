import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import LineGraph from '../Base/LineGraph';

export function GrowthOfGroupsGraph(props) {
  return (
    <LineGraph
      config={{
        x: { field: 'date', title: 'Date' },
        y: { field: 'count', title: 'Member count' },
        color: { field: 'name', title: 'Group' }
      }}
      data={props.data}
      {...props}
    />
  );
}

GrowthOfGroupsGraph.propTypes = {
  data: PropTypes.array,
  titles: PropTypes.array,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
)(GrowthOfGroupsGraph);
