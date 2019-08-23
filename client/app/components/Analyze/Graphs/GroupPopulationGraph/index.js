import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Grid, Paper } from '@material-ui/core';

import {
  XYPlot, HorizontalBarSeries, VerticalGridLines, HorizontalGridLines,
  Hint, XAxis, YAxis
} from 'react-vis/';
import '../../../../../node_modules/react-vis/dist/style.css'; // TODO: fix this nonsense

import BarGraph from '../Base/BarGraph';

export function GroupPopulationGraph(props) {
  const [value, setValue] = useState(undefined);

  return (
    <BarGraph
      data={props.data}
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
