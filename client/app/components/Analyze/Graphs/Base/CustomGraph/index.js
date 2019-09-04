import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  Grid, Paper, withStyles, Box,
  Button
} from '@material-ui/core';

import {
  FlexibleWidthXYPlot, HorizontalBarSeries, VerticalGridLines, HorizontalGridLines,
  Hint, XAxis, YAxis
} from 'react-vis/';
import 'react-vis/dist/style.css';

import RangeSelector from 'components/Analyze/Shared/RangeSelector';

const styles = theme => ({
  paper: {
    padding: theme.spacing(3),
  },
});

export function CustomGraph(props) {
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
            tickFormat={value => (value.length > 8) ? `${value.substring(0, 11)}...` : value}
          />
          <HorizontalGridLines />
          <VerticalGridLines />
          <HorizontalBarSeries
            data={props.data}
            barWidth={0.7}
            onValueMouseOver={value => setValue(value)}
          />
          {value && <Hint value={{ x: value.x, y: value.y }} />}
        </FlexibleWidthXYPlot>
        <Box mb={2} />
      </Paper>
    </React.Fragment>
  );
}

CustomGraph.propTypes = {
  classes: PropTypes.object,
  data: PropTypes.array,
  updateRange: PropTypes.func,
  handleDrilldown: PropTypes.func,
  isDrilldown: PropTypes.bool,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles),
)(CustomGraph);
