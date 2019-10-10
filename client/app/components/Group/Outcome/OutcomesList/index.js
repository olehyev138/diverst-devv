/**
 *
 * Outcomes List Component
 *
 */

import React, { memo, useContext, useState } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import withStyles from '@material-ui/core/styles/withStyles';

import {
  Grid, Card, CardContent, Typography, Link, CardActions, Button, Divider, Box,
} from '@material-ui/core';

import messages from 'containers/Group/Outcome/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import ListItemIcon from '@material-ui/icons/Remove';
import AddIcon from '@material-ui/icons/Add';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

const styles = theme => ({
  floatRight: {
    float: 'right',
    marginBottom: 24,
  }
});

export function OutcomesList(props, context) {
  const { classes, intl } = props;

  return (
    <React.Fragment>
      <Button
        className={classes.floatRight}
        variant='contained'
        to={props.links.outcomeNew}
        color='primary'
        size='large'
        component={WrappedNavLink}
        startIcon={<AddIcon />}
      >
        <DiverstFormattedMessage {...messages.new} />
      </Button>
      <DiverstLoader isLoading={props.isLoading}>
        <Grid container>
          { /* eslint-disable-next-line arrow-body-style */}
          {props.outcomes && props.outcomes.map((outcome, i) => (
            <Grid item key={outcome.id} xs={12}>
              <Card>
                <CardContent>
                  <Typography variant='h6' gutterBottom>
                    {outcome.name}
                  </Typography>
                  <Box mb={1} mt={2}>
                    <Typography color='textSecondary'>
                      <DiverstFormattedMessage {...messages.pillars.text} />
                    </Typography>
                    <Divider />
                  </Box>
                  {outcome.pillars && outcome.pillars.map((pillar, i) => (
                    <React.Fragment key={pillar.id}>
                      <Typography gutterBottom>
                        <ListItemIcon color='secondary' />
                        {pillar.name}
                      </Typography>
                    </React.Fragment>
                  ))}
                  {(!outcome.pillars || outcome.pillars.length <= 0) && (
                    <Typography>
                      There are no pillars for this outcome.
                    </Typography>
                  )}
                </CardContent>
                <CardActions>
                  <Button
                    component={WrappedNavLink}
                    color='primary'
                    to={props.links.outcomeEdit(outcome.id)}
                  >
                    Manage
                  </Button>
                </CardActions>
              </Card>
              <Box mb={3} />
            </Grid>
          ))}
        </Grid>
      </DiverstLoader>
      <DiverstPagination
        isLoading={props.isLoading}
        rowsPerPage={props.defaultParams.count}
        count={props.outcomeTotal}
        handlePagination={props.handlePagination}
      />
    </React.Fragment>
  );
}

OutcomesList.propTypes = {
  intl: PropTypes.object,
  classes: PropTypes.object,
  outcomes: PropTypes.array,
  outcomeTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  defaultParams: PropTypes.object,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles)
)(OutcomesList);
