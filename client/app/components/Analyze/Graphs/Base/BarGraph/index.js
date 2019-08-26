import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Grid, Paper, withStyles } from '@material-ui/core';

import {
  FlexibleWidthXYPlot, HorizontalBarSeries, VerticalGridLines, HorizontalGridLines,
  Hint, XAxis, YAxis
} from 'react-vis/';
import 'react-vis/dist/style.css';

import RangeSelector from 'components/Analyze/Shared/RangeSelector';
import Box from '@material-ui/core/Box';

const styles = theme => ({
  paper: {
    padding: theme.spacing(3),
  },
});

export function BarGraph(props) {
  const { classes } = props;
  const [value, setValue] = useState(undefined);

  return (
    <React.Fragment>
      <Paper className={classes.paper}>
        <RangeSelector updateRange={props.updateRange} />
        <Box mb={2} />
        <FlexibleWidthXYPlot
          yType='ordinal'
          margin={{ left: 100 }}
          height={500}
          onMouseLeave={() => setValue(undefined)}
          {...props}
        >
          <XAxis />
          <YAxis
            tickFormat={(value) => {
              return (value.length > 8) ? `${value.substring(0, 11)}...` : value;
            }}
          />
          <HorizontalGridLines />
          <VerticalGridLines />
          <HorizontalBarSeries
            data={props.data}
            barWidth={0.7}
            onValueMouseOver={value => setValue(value)}
          />
          {value && <Hint value={value} />}
        </FlexibleWidthXYPlot>
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
