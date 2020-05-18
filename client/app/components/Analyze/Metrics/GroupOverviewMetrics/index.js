import React, { memo, useEffect, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import { Paper, Box, CardContent, Typography, Grid } from '@material-ui/core';

export function GroupOverviewMetrics({ data }) {
  return (
    <React.Fragment>
      <Grid container spacing={2}>
        <Grid item xs={6}>
          <Paper>
            <CardContent>
              <Typography display='inline' variant='h6' color='primary'>
                Total groups: &nbsp;
              </Typography>
              <Typography display='inline' variant='h6'>
                {data.total_groups}
              </Typography>
            </CardContent>
          </Paper>
        </Grid>
        <Grid item xs={6}>
          <Paper>
            <CardContent>
              <Typography display='inline' variant='h6' color='primary'>
                Average members: &nbsp;
              </Typography>
              <Typography display='inline' variant='h6'>
                {data.avg_nb_members_per_group}
              </Typography>
            </CardContent>
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
