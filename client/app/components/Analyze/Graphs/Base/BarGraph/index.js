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

function configureBarGraph(spec, config) {
  spec.encoding.x.field = config.x.field;
  spec.encoding.x.title = config.x.title;
  spec.encoding.y.field = config.y.field;
  spec.encoding.y.title = config.y.title;
  spec.encoding.y.sort.field = config.x.field;
  spec.encoding.color.field = config.color.field;
}

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
    y: { field: '', type: 'nominal', title: '', sort: { field: '', order: 'descending' } },
    x: { field: '', type: 'quantitative', title: '' },
    color: { field: '', type: 'nominal', title: '' },
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
              "length(data('select_store'))"
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

  configureBarGraph(spec, props.config);

  return (
    <React.Fragment>
      <Paper className={classes.paper}>
        <VegaLite spec={spec} data={{ values: (props.data || []) }} />
      </Paper>
    </React.Fragment>
  );
}

BarGraph.propTypes = {
  data: PropTypes.array,
  config: PropTypes.object,
  classes: PropTypes.object,
  updateRange: PropTypes.func,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles),
)(BarGraph);
