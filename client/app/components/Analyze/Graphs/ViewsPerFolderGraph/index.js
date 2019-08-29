import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import BarGraph from '../Base/BarGraph';

export function ViewsPerFolderGraph(props) {
  const [value, setValue] = useState(undefined);

  return (
    <BarGraph
      data={props.data}
      {...props}
    />
  );
}

ViewsPerFolderGraph.propTypes = {
  data: PropTypes.array,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
)(ViewsPerFolderGraph);
