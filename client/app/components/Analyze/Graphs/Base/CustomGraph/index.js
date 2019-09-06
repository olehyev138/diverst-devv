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
import { Edit, DeleteOutline } from '@material-ui/icons';
import 'react-vis/dist/style.css';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
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
        <Grid container justify='flex-end'>
          <Grid item>
            <Button
              component={WrappedNavLink}
              to={props.links.customGraphEdit(props.customGraph.id)}
            >
              <Edit />
            </Button>
          </Grid>
          <Grid item>
            <Button
              onClick={() => {
                /* eslint-disable-next-line no-alert, no-restricted-globals */
                if (confirm('Delete metricsDashboard?'))
                  props.deleteCustomGraphBegin(props.customGraph.id);
              }}
            >
              <DeleteOutline />
            </Button>
          </Grid>
        </Grid>
        <RangeSelector updateRange={props.updateRange} />
        <Box mb={2} />
        <FlexibleWidthXYPlot
          yType='ordinal'
          margin={{ left: 100 }}
          height={500}
          onMouseLeave={() => setValue(undefined)}
          stackBy='x'
          {...props}
        >
          <XAxis />
          <YAxis
            tickFormat={value => (value.length > 8) ? `${value.substring(0, 11)}...` : value}
          />
          <HorizontalGridLines />
          <VerticalGridLines />
          { props.data && props.data.map((series, index) => {
            // TODO: hide/show series with legend like line graph
            // if (dig(legendData[series.key], 'hidden')) return (<React.Fragment key={series.key} />);

            return (
              <HorizontalBarSeries
                key={series.key}
                data={series.values}
                onValueMouseOver={value => {
                  setValue(value);
                }}
              />
            );
          })}
          {value && <Hint value={{ x: (value.x - (value.x0 ? value.x0 : 0)), y: value.series }} />}
        </FlexibleWidthXYPlot>
        <Box mb={2} />
      </Paper>
    </React.Fragment>
  );
}

CustomGraph.propTypes = {
  classes: PropTypes.object,
  data: PropTypes.array,
  customGraph: PropTypes.object,
  links: PropTypes.object,
  updateRange: PropTypes.func,
  handleDrilldown: PropTypes.func,
  isDrilldown: PropTypes.bool,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
  withStyles(styles),
)(CustomGraph);
