import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import produce from 'immer';
import dig from 'object-dig';

import {
  Grid, Paper, withStyles, Box,
  Button
} from '@material-ui/core';

import {
  FlexibleWidthXYPlot, HorizontalBarSeries, VerticalGridLines, HorizontalGridLines,
  Hint, XAxis, YAxis, DiscreteColorLegend, makeWidthFlexible
} from 'react-vis/';
import { Edit, DeleteOutline } from '@material-ui/icons';
import 'react-vis/dist/style.css';

import 'react-perfect-scrollbar/dist/css/styles.css';
import PerfectScrollbar from 'react-perfect-scrollbar';

import WrappedNavLink from 'components/Shared/WrappedNavLink';
import RangeSelector from 'components/Analyze/Shared/RangeSelector';
import { injectIntl, intlShape } from 'react-intl';
import messages from 'containers/Analyze/messages';
const FlexibleWidthDiscreteColorLegend = makeWidthFlexible(DiscreteColorLegend);

const styles = theme => ({
  paper: {
    padding: theme.spacing(3),
  },
});

export function CustomGraph(props) {
  const { classes, intl } = props;
  const [value, setValue] = useState(undefined);
  const [legendData, setLegendData] = useState({});

  const buildLegendData = (data, hidden = false) => {
    if (!data) return [];

    const newLegendData = {};
    data.forEach((d) => { newLegendData[d.key] = { title: d.key, hidden }; });

    return newLegendData;
  };

  useEffect(() => {
    setLegendData(buildLegendData(props.data));
  }, [props.data]);

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
                if (confirm(intl.formatMessage(messages.delete_confirm)))
                  props.deleteCustomGraphBegin({
                    dashboardId: props.customGraph.metrics_dashboard_id,
                    graphId: props.customGraph.id
                  });
              }}
            >
              <DeleteOutline />
            </Button>
          </Grid>
        </Grid>
        <PerfectScrollbar>
          <FlexibleWidthDiscreteColorLegend
            style={{
              overflow: 'visible',
              paddingBottom: 16,
            }}
            items={Object.values(legendData)}
            orientation='horizontal'
            onItemClick={(v) => {
              const updatedLegendData = produce(legendData, (draft) => {
                draft[v.title].hidden = !draft[v.title].hidden;
              });

              setLegendData(updatedLegendData);
            }}
          />
        </PerfectScrollbar>
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
            if (dig(legendData[series.key], 'hidden')) return (<React.Fragment key={series.key} />);

            return (
              <HorizontalBarSeries
                key={series.key}
                data={series.values}
                onValueMouseOver={value => setValue(value)}
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
  intl: intlShape,
  data: PropTypes.array,
  customGraph: PropTypes.object,
  links: PropTypes.object,
  updateRange: PropTypes.func,
  deleteCustomGraphBegin: PropTypes.func,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
  injectIntl,
  withStyles(styles),
)(CustomGraph);
