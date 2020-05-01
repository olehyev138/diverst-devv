import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import BarGraph from '../Base/BarGraph';

export function GroupPopulationGraph(props) {
  const [value, setValue] = useState(undefined);

  return (
    <BarGraph
      config={{
        x: { field: 'count', title: 'Members' },
        y: { field: 'name', title: 'Groups' }
      }}
      data={props.data}
      {...props}
    />
  );
}

GroupPopulationGraph.propTypes = {
  data: PropTypes.array,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
)(GroupPopulationGraph);
