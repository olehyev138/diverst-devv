/**
 *
 * PollShowHeader List
 *
 */

import React, { memo, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';

import {
  CardContent, Grid, Divider, Typography, Button, Box, Card
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import messages from 'containers/Poll/messages';
import { injectIntl, intlShape } from 'react-intl';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import { percent } from 'utils/floatRound';

const styles = theme => ({
  PollShowHeaderItem: {
    width: '100%',
  },
  PollShowHeaderItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function PollShowHeader(props, context) {
  const { classes } = props;
  const { links, intl, poll } = props;

  return (
    <React.Fragment>
      <Grid container spacing={3} justify='space-between'>
        <Grid item xs='auto'>
          <Typography variant='h5'>
            {poll.title}
          </Typography>
        </Grid>
        <Grid item xs='auto'>
          <Button
            component={WrappedNavLink}
            to={links.pollsIndex}
            variant='contained'
            color='primary'
          >
            Back
          </Button>
        </Grid>
      </Grid>
      <Box mb={2} />
      <Card>
        <CardContent>
          <Typography variant='body1' color='secondary'>
            {poll.description}
          </Typography>
          <Box mb={2} />
          <Grid container>
            <Grid item sm={6} md={3} lg={2}>
              <Typography variant='body2'>
                Invitations
              </Typography>
              <Typography variant='h6'>
                {poll.targeted_users_count}
              </Typography>
            </Grid>
            <Grid item sm={6} md={3} lg={2}>
              <Typography variant='body2'>
                Responses
              </Typography>
              <Typography variant='h6'>
                {poll.responses_count}
              </Typography>
            </Grid>
            <Grid item sm={6} md={3} lg={2}>
              <Typography variant='body2'>
                Response Rate
              </Typography>
              <Typography variant='h6'>
                {
                  poll.targeted_users_count > 0
                    ? `${percent(poll.responses_count, poll.targeted_users_count)}%`
                    : 'N/A'
                }
              </Typography>
            </Grid>
          </Grid>
        </CardContent>
      </Card>
    </React.Fragment>
  );
}
PollShowHeader.propTypes = {
  intl: intlShape,
  classes: PropTypes.object,
  poll: PropTypes.object,
  links: PropTypes.shape({
    pollIndex: PropTypes.string,
  })
};
export default compose(
  injectIntl,
  memo,
  withStyles(styles),
)(PollShowHeader);
