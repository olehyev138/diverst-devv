import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { VegaLite } from 'react-vega';

import {
  Paper, withStyles
} from '@material-ui/core';

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
    y: { field: 'folder', type: 'nominal', title: 'Folder', sort: { field: 'count', order: 'descending' } },
    x: { field: 'count', type: 'quantitative', title: 'Views' },
    color: { field: 'name', type: 'nominal', title: 'Group' },
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

export function ColoredBarGraph(props) {
  const { classes } = props;

  return (
    <React.Fragment>
      <Paper className={classes.paper}>
        <VegaLite spec={spec} data={{ values: (props.data || []) }} />
      </Paper>
    </React.Fragment>
  );
}

ColoredBarGraph.propTypes = {
  data: PropTypes.array,
  classes: PropTypes.object,
  updateRange: PropTypes.func,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles),
)(ColoredBarGraph);
