import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import 'react-perfect-scrollbar/dist/css/styles.css';
import PerfectScrollbar from 'react-perfect-scrollbar';

import produce from 'immer';
import dig from 'object-dig';

import {
  Grid, Paper, Button, withStyles,
} from '@material-ui/core';

import {
  makeWidthFlexible, FlexibleWidthXYPlot, LineSeries, VerticalGridLines, HorizontalGridLines,
  Hint, XAxis, YAxis, Highlight, Crosshair, Borders, DiscreteColorLegend
} from 'react-vis/';
import 'react-vis/dist/style.css';
import RangeSelector from 'components/Analyze/Shared/RangeSelector';

const FlexibleWidthDiscreteColorLegend = makeWidthFlexible(DiscreteColorLegend);


const styles = theme => ({
  paper: {
    padding: theme.spacing(3),
  },
  legend: {
    overflow: 'visible',
  },
});

export function LineGraph(props) {
  const { classes } = props;

  const [lastDrawLocation, setLastDrawLocation] = useState(null);
  const [values, setValues] = useState([]);

  const [legendData, setLegendData] = useState({});

  const buildLegendData = (data, hidden = false) => {
    const newLegendData = {};
    data.forEach((d) => { newLegendData[d.key] = { title: d.key, hidden }; });

    return newLegendData;
  };

  // TODO: use a boolean or something to indicate data is still loading
  if (props.data && props.data[0].key !== 'dummy' && legendData && Object.keys(legendData).length <= 0)
    setLegendData(buildLegendData(props.data));

  // TODO: updating state with different values causes highlighting & crosshair lag
  const updateCrossHairs = (v, { index }) => setValues(props.data.map(d => d.values[index]));


  return (
    <React.Fragment>
      <Paper className={classes.paper}>
        <RangeSelector updateRange={props.updateRange} />
        <PerfectScrollbar>
          <FlexibleWidthDiscreteColorLegend
            style={{
              overflow: 'visible',
              paddingBottom: 16,
            }}
            items={Object.values(legendData)}
            orientation='horizontal'
            onItemClick={(v) => {
              const p = produce(legendData, (draft) => {
                draft[v.title].hidden = !draft[v.title].hidden;
              });

              setLegendData(p);
            }}
          />
        </PerfectScrollbar>
        <br />
        <FlexibleWidthXYPlot
          animation
          height={500}
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
        </FlexibleWidthXYPlot>
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
