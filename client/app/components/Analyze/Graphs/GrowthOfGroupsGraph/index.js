import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import produce from 'immer';
import dig from 'object-dig';

import {
  Grid, Paper, Button
} from '@material-ui/core';

import {
  XYPlot, LineSeries, VerticalGridLines, HorizontalGridLines,
  Hint, XAxis, YAxis, Highlight, Crosshair, Borders, DiscreteColorLegend
} from 'react-vis/';
import 'react-vis/dist/style.css'; // TODO: fix this nonsense

import LineGraph from '../Base/LineGraph';

export function GrowthOfGroupsGraph(props) {
  return (
    <LineGraph
      data={props.data}
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
