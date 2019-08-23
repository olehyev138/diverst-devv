import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Grid, Paper } from '@material-ui/core';

import {
  XYPlot, HorizontalBarSeries, VerticalGridLines, HorizontalGridLines,
  Hint, XAxis, YAxis
} from 'react-vis/';
import '../../../../../../node_modules/react-vis/dist/style.css'; // TODO: fix this nonsense

export function BarGraph(props) {
  const [value, setValue] = useState(undefined);

  return (
    <React.Fragment>
      <Paper>
        <Grid container justify='center'>
          <XYPlot
            yType='ordinal'
            animation='stiff'
            height={500}
            width={700}
            margin={{ left: 100 }}
            onMouseLeave={() => setValue(undefined)}
          >
            <XAxis />
            <YAxis
              tickFormat={(value) => {
                return (value.length > 8) ? `${value.substring(0, 8)}...` : value;
              }}
            />
            <HorizontalGridLines />
            <VerticalGridLines />
            <HorizontalBarSeries
              data={props.data}
              barWidth={0.7}
              onValueMouseOver={value => setValue(value)}
            />
            { value && <Hint value={value} /> }
          </XYPlot>
        </Grid>
      </Paper>
    </React.Fragment>
  );
}

BarGraph.propTypes = {
  data: PropTypes.array,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
)(BarGraph);
