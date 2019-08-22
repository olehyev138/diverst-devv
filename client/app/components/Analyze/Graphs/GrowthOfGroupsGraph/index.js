import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import dig from 'object-dig';

import { Grid, Paper } from '@material-ui/core';

import {
  XYPlot, LineSeries, VerticalGridLines, HorizontalGridLines,
  Hint, XAxis, YAxis, Highlight
} from 'react-vis/';
import '../../../../../node_modules/react-vis/dist/style.css'; // TODO: fix this nonsense

export function GrowthOfGroupsGraph(props) {
  const [value, setValue] = useState(undefined);

  const [lastDrawLocation, setLastDrawLocation] = useState(null);

  return (
    <React.Fragment>
      <Paper>
        <Grid container justify='center'>
          <XYPlot
            animation
            height={500}
            width={700}
            margin={{ left: 100 }}
            xDomain={
              lastDrawLocation && [
                lastDrawLocation.left,
                lastDrawLocation.right
              ]
            }
            yDomain={
              lastDrawLocation && [
                lastDrawLocation.bottom,
                lastDrawLocation.top
              ]
            }
          >
            <XAxis
              tickPadding={20}
              tickLabelAngle={10}
              tickFormat={value => new Date(value).toLocaleDateString()}
            />
            <YAxis />
            <HorizontalGridLines />
            <VerticalGridLines />
            { props.data.slice(0, 20).map(series => (
              <LineSeries
                key={series.key}
                data={series.values}
              />
            ))}
            <Highlight
              onBrushEnd={area => setLastDrawLocation(area)}
              onDrag={(area) => {
                setLastDrawLocation({
                  bottom: lastDrawLocation.bottom + (area.top - area.bottom),
                  left: lastDrawLocation.left - (area.right - area.left),
                  right: lastDrawLocation.right - (area.right - area.left),
                  top: lastDrawLocation.top + (area.top - area.bottom)
                });
              }}
            />
          </XYPlot>
        </Grid>
      </Paper>
    </React.Fragment>
  );
}

GrowthOfGroupsGraph.propTypes = {
  data: PropTypes.array,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
)(GrowthOfGroupsGraph);
