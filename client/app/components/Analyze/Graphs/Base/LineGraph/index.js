import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import produce from 'immer';
import dig from 'object-dig';

import {
  Grid, Paper, Button
} from '@material-ui/core';

import {
  XYPlot, LineSeries, VerticalGridLines, HorizontalGridLines,
  Hint, XAxis, YAxis, Highlight, Crosshair, Borders, DiscreteColorLegend
} from 'react-vis/';
import 'react-vis/dist/style.css';

export function LineGraph(props) {
  const [lastDrawLocation, setLastDrawLocation] = useState(null);
  const [values, setValues] = useState([]);

  const [legendData, setLegendData] = useState({});

  const buildLegendData = (data, hidden = false) => {
    const newLegendData = {};
    data.forEach((d) => { newLegendData[d.key] = { title: d.key, hidden }; });

    return newLegendData;
  };

  if (props.data && props.data.length > 0 && legendData && Object.keys(legendData).length <= 0)
    setLegendData(buildLegendData(props.data));

  // TODO: updating state with different values causes highlighting & crosshair lag
  const updateCrossHairs = (v, { index }) => setValues(props.data.map(d => d.values[index]));


  return (
    <React.Fragment>
      <Paper>
        <Grid container justify='center'>
          <Grid item xs={6}>
            <DiscreteColorLegend
              items={Object.values(legendData)}
              orientation='horizontal'
              height={100}
              onItemClick={v => {
                const p = produce(legendData, draft => {
                  draft[v.title].hidden = !draft[v.title].hidden;
                });

                setLegendData(p);
              }}
            />
          </Grid>
        </Grid>
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
            <HorizontalGridLines />
            <VerticalGridLines />
            { props.data && props.data.map((series, index) => {
              if (dig(legendData[series.key], 'hidden')) return (<React.Fragment key={series.key} />);

              return (
                <LineSeries
                  key={series.key}
                  data={series.values}
                />
              );
            })}
            <Borders style={{ all: { fill: '#fff' }}} />
            <XAxis
              tickPadding={20}
              tickLabelAngle={10}
              tickFormat={value => new Date(value).toLocaleDateString()}
            />
            <YAxis />
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

LineGraph.propTypes = {
  data: PropTypes.array,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
)(LineGraph);
