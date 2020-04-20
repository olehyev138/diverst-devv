import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Paper, withStyles,
} from '@material-ui/core';

import { VegaLite } from 'react-vega';

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
        field: 'date',
        type: 'temporal',
        scale: { domain: { selection: 'brush' } }
      }
    },
    layer: [{
      encoding: {
        color: { field: 'name', type: 'nominal' },
        y: { field: 'count', type: 'quantitative' }
      },
      layer: [
        {
          mark: 'line',
          selection: {
            legend: {
              type: 'multi', fields: ['name'], bind: 'legend'
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
      transform: [{ pivot: 'name', value: 'count', groupby: ['date'] }],
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
          fields: ['date'],
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
      x: { field: 'date', type: 'temporal' },
      color: { field: 'name', type: 'nominal' },
      y: { field: 'count', type: 'quantitative' }
    }
  }]
};

export function LineGraph(props) {
  const { classes } = props;

  return (
    <React.Fragment>
      <Paper className={classes.paper}>
        <RangeSelector updateRange={props.updateDateFilters} />
        <VegaLite spec={spec} data={{ values: (props.data || []) }} />
      </Paper>
    </React.Fragment>
  );
}

LineGraph.propTypes = {
  classes: PropTypes.object,
  data: PropTypes.array,
  updateDateFilters: PropTypes.func,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles)
)(LineGraph);
