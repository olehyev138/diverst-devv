import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import LineGraph from '../Base/LineGraph';

export function GrowthOfResourcesGraph(props) {
  return (
    <LineGraph
      data={props.data}
      {...props}
    />
  );
}

GrowthOfResourcesGraph.propTypes = {
  data: PropTypes.array,
  titles: PropTypes.array,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
)(GrowthOfResourcesGraph);
