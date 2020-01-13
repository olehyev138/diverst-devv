import React, { memo } from 'react';

import { compose } from 'redux';
import PropTypes from 'prop-types';

import { withStyles } from '@material-ui/core/styles';
import { Card, CardHeader, Grid } from '@material-ui/core';
import KPIMetricCell from '../KPIMetricCell';
import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';

const styles = theme => ({
  table: {
  },
  th: {
    'background-color': 'green',
    Color: 'white',
  },
  td: {
    width: '150px',
    'text-align': 'center',
    border: '1px solid black',
    padding: '5px',
  }
});

export function KPI(props) {
  const { classes, metrics } = props;

  const { __updates__, ...data } = metrics;

  return (
    Object.keys(metrics).length ? (
      <React.Fragment>
        <DiverstLoader isLoading={props.isFetching}>
          <Grid container spacing={1}>
            <Grid item md={2}>
              <Card>
                <CardHeader
                  title='Metrics'
                />
              </Card>
            </Grid>
            {__updates__.map(update => (
              <Grid item md={2} key={update.id}>
                <KPIMetricCell
                  update={update}
                  type='update'
                />
              </Grid>
            ))}
          </Grid>
          {Object.keys(data).map(key => (
            <Grid container spacing={1}>
              <Grid item md={2} key={key}>
                <KPIMetricCell
                  field={key}
                  type='field'
                />
              </Grid>
              { data[key].map(value => (
                <Grid item md={2} key={data.update_id}>
                  <KPIMetricCell
                    data={value}
                    type='data'
                  />
                </Grid>
              ))}
            </Grid>
          ))}
        </DiverstLoader>
        {Object.keys(metrics).length > 0 && (
          <DiverstPagination
            isLoading={props.isFetching}
            count={props.count}
            rowsPerPage={5}
            handlePagination={props.handlePagination}
          />
        )}
      </React.Fragment>
    ) : (
      <React.Fragment />
    )
  );
}

KPI.propTypes = {
  classes: PropTypes.object,
  metrics: PropTypes.object,
  isFetching: PropTypes.bool,
  count: PropTypes.number,
  handlePagination: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles),
)(KPI);
