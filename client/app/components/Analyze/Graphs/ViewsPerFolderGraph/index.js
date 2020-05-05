import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import BarGraph from '../Base/BarGraph';
import ColoredBarGraph from '../Base/ColoredBarGraph';

export function ViewsPerFolderGraph(props) {
  const [value, setValue] = useState(undefined);

  console.log(props);

  return (
    <ColoredBarGraph
      config={{
        x: { field: 'count', title: 'Views' },
        y: { field: 'folder', title: 'Folder' },
        color: { field: 'name', title: 'Group' }
      }}
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
