import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Paper, Typography, Grid } from '@material-ui/core';

export function GroupOverviewMetrics({ data }) {
  return (
    <React.Fragment>
      <Grid container spacing={2}>
        <Grid item xs={6} spacing={2}>
          <Paper>
            <Typography variant='h4'>Total groups: {data.total_groups}</Typography>
          </Paper>
        </Grid>
        <Grid item xs={6}>
          <Paper>
            <Typography variant='h4'>Average members: {data.avg_nb_members_per_group}</Typography>
          </Paper>
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

GroupOverviewMetrics.propTypes = {
  data: PropTypes.object,
  metricsUnmount: PropTypes.func
};

export default compose(
  memo,
)(GroupOverviewMetrics);
