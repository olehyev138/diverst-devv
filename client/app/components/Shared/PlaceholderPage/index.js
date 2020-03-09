/**
 *
 * PlaceholderPage
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'components/Shared/PlaceholderPage/messages';

import {
  Typography, Grid, Card, CardContent, Divider
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

const styles = theme => ({
  pageTitle: {
    paddingBottom: 24,
  },
});

function PlaceholderPage(props, context) {
  const { classes, pageTitle } = props;
  const { intl } = context;

  return (
    <React.Fragment>
      {
        pageTitle ? (
          <Typography variant='h4' className={classes.pageTitle}>
            <DiverstFormattedMessage {...pageTitle} />
          </Typography>
        )
          : null
      }
      <Grid container spacing={3} justify='center'>
        <Grid item xs={12} sm={6} md={4}>
          <Card>
            <CardContent>
              <Typography variant='h5'>
                <DiverstFormattedMessage {...messages.example} />
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={6} md={4}>
          <Card>
            <CardContent>
              <Typography variant='h5'>
                <DiverstFormattedMessage {...messages.example} />
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={9} md={4}>
          <Card>
            <CardContent>
              <Typography variant='h5'>
                <DiverstFormattedMessage {...messages.example} />
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
      <br />
      <Divider variant='middle' />
      <br />
      <Grid container spacing={3}>
        <Grid item xs={12} sm={4} md={3}>
          <Card>
            <CardContent>
              <Typography variant='h5'>
                <DiverstFormattedMessage {...messages.example} />
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={4} md={6}>
          <Card>
            <CardContent>
              <Typography variant='h5'>
                <DiverstFormattedMessage {...messages.example} />
              </Typography>
            </CardContent>
          </Card>
        </Grid>
        <Grid item xs={12} sm={4} md={3}>
          <Card>
            <CardContent>
              <Typography variant='h5'>
                <DiverstFormattedMessage {...messages.example} />
              </Typography>
            </CardContent>
          </Card>
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

PlaceholderPage.propTypes = {
  classes: PropTypes.object,
  pageTitle: PropTypes.object,
};

export default memo(withStyles(styles)(PlaceholderPage));
