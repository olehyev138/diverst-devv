import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import BarGraph from '../Base/BarGraph';

export function ViewsPerResourceGraph(props) {
  const [value, setValue] = useState(undefined);

  return (
    <BarGraph
      data={props.data}
      {...props}
    />
  );
}

ViewsPerResourceGraph.propTypes = {
  data: PropTypes.array,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
)(ViewsPerResourceGraph);
