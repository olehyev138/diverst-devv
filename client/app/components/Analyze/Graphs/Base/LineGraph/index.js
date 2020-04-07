import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { VegaLite } from 'react-vega';

import 'react-perfect-scrollbar/dist/css/styles.css';
import PerfectScrollbar from 'react-perfect-scrollbar';

import produce from 'immer';
import dig from 'object-dig';

import {
  Grid, Paper, Button, withStyles,
} from '@material-ui/core';

import RangeSelector from 'components/Analyze/Shared/RangeSelector';

const styles = theme => ({
  paper: {
    padding: theme.spacing(3),
  },
  legend: {
    overflow: 'visible',
  },
});

const spec = {
  $schema: 'https://vega.github.io/schema/vega-lite/v4.json',
  width: 400,
  height: 200,
  padding: { left: 5, right: 5, top: 5, bottom: 5 },

  data: { name: 'values' },

  vconcat: [{
    width: 480,
    mark: 'line',
    encoding: {
      x: {
        field: 'x',
        type: 'temporal',
        scale: { domain: { selection: 'brush' } }
      }
    },
    layer: [{
      encoding: {
        color: { field: 'key', type: 'nominal' },
        y: { field: 'y', type: 'quantitative' }
      },
      layer: [
        {
          mark: 'line',
          selection: {
            legend: {
              type: 'multi', fields: ['key'], bind: 'legend'
            }
          },
          encoding: {
            opacity: {
              condition: { selection: 'legend', value: 1 },
              value: 0.2
            }
          }
        },
        { transform: [{ filter: { selection: 'hover' } }], mark: 'point' }
      ]
    }, {
      transform: [{ pivot: 'key', value: 'y', groupby: ['x'] }],
      mark: 'rule',
      encoding: {
        opacity: {
          condition: { value: 0.3, selection: 'hover' },
          value: 0
        },
      },
      selection: {
        hover: {
          type: 'single',
          fields: ['x'],
          nearest: true,
          on: 'mouseover',
          empty: 'none',
          clear: 'mouseout'
        }
      }
    }]
  }, {
    width: 480,
    height: 60,
    mark: 'line',
    selection: {
      brush: { type: 'interval', encodings: ['x'] }
    },
    encoding: {
      x: { field: 'x', type: 'temporal' },
      color: { field: 'key', type: 'nominal' },
      y: { field: 'y', type: 'quantitative' }
    }
  }]
};

export function LineGraph(props) {
  const { classes } = props;

  // TODO: move this to backend
  /* flatten */

  const flattened = [];

  if (props.data)
    props.data.map(s => {
      s.values.map(d => {
        flattened.push({ key: s.key, x: d.x, y: d.y });
      });
    });

  return (
    <React.Fragment>
      <Paper className={classes.paper}>
        <VegaLite spec={spec} data={{ values: flattened }} />
      </Paper>
    </React.Fragment>
  );
}

LineGraph.propTypes = {
  classes: PropTypes.object,
  data: PropTypes.array,
  updateRange: PropTypes.func,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles)
)(LineGraph);
