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

/* Function to allow configuring of line graph spec */
function configureLineGraph(spec, config) {
  spec.vconcat[0].encoding.x.field = config.x.field;
  spec.vconcat[0].encoding.x.title = config.x.title;
  spec.vconcat[0].layer[0].encoding.color.field = config.color.field;
  spec.vconcat[0].layer[0].encoding.color.title = config.color.title;
  spec.vconcat[0].layer[0].encoding.y.field = config.y.field;
  spec.vconcat[0].layer[0].encoding.y.title = config.y.title;
  spec.vconcat[0].layer[0].layer[0].selection.legend.fields[0] = config.color.field;
  spec.vconcat[0].layer[0].layer[1].transform.pivot = config.color.field;
  spec.vconcat[0].layer[0].layer[1].transform.value = config.y.field;
  spec.vconcat[0].layer[0].layer[1].transform.groupby = config.x.field;
  spec.vconcat[0].layer[1].selection.hover.fields[0] = config.x.field;
  spec.vconcat[1].encoding.x.field = config.x.field;
  spec.vconcat[1].encoding.x.title = config.x.title;
  spec.vconcat[1].encoding.y.field = config.y.field;
  spec.vconcat[1].encoding.y.title = config.y.title;
  spec.vconcat[1].encoding.color.field = config.color.field;
}

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
        scale: { domain: { selection: 'brush' } },
        title: 'Date'
      }
    },
    layer: [{
      encoding: {
        color: { field: 'name', type: 'nominal', title: 'Groups' },
        y: { field: 'count', type: 'quantitative', title: 'Members' }
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
      x: { field: 'date', type: 'temporal', title: 'Date' },
      color: { field: 'name', type: 'nominal' },
      y: { field: 'count', type: 'quantitative', title: 'Group' }
    }
  }]
};

export function LineGraph(props) {
  const { classes } = props;

  configureLineGraph(spec, props.config);

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
  config: PropTypes.object,
  updateDateFilters: PropTypes.func,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles)
)(LineGraph);
