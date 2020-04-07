import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { VegaLite } from 'react-vega';

import {
  Grid, Paper, withStyles, Box,
  Button
} from '@material-ui/core';

import RangeSelector from 'components/Analyze/Shared/RangeSelector';

const styles = theme => ({
  paper: {
    padding: theme.spacing(3),
  },
});

const spec = {
  $schema: 'https://vega.github.io/schema/vega-lite/v4.json',
  width: 400,
  height: 200,
  padding: { left: 5, right: 5, top: 5, bottom: 5 },
  data: { name: 'values' },

  mark: {
    type: 'bar',
    stroke: 'black',
    cursor: 'pointer',
    tooltip: true
  },
  selection: {
    highlight: { type: 'single', empty: 'none', on: 'mouseover' },
    select: { type: 'multi' }
  },

  encoding: {
    y: { field: 'y', type: 'nominal', title: 'Group' },
    x: { field: 'x', type: 'quantitative', title: 'Members' },
    fillOpacity: {
      condition: { selection: 'select', value: 1 },
      value: 0.3
    },
    strokeWidth: {
      condition: [
        {
          test: {
            and: [
              { selection: 'select' },
              "length(data(\"select_store\"))"
            ]
          },
          value: 2
        },
        { selection: 'highlight', value: 1 }
      ],
      value: 0
    }
  }
};

export function BarGraph(props) {
  const { classes } = props;
  const [value, setValue] = useState(undefined);

  return (
    <React.Fragment>
      <Paper className={classes.paper}>
        <VegaLite spec={spec} data={{ values: (props.data && props.data.length !== 0) ? props.data : [] }} />
      </Paper>
    </React.Fragment>
  );
}

BarGraph.propTypes = {
  classes: PropTypes.object,
  data: PropTypes.array,
  updateRange: PropTypes.func,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles),
)(BarGraph);
