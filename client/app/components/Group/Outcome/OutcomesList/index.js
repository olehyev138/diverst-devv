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
  Grid, Card, CardContent, Typography, CardActions, Button, Divider, Box,
} from '@material-ui/core';

import messages from 'containers/Group/Outcome/messages';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

import ListItemIcon from '@material-ui/icons/Remove';
import AddIcon from '@material-ui/icons/Add';
import BackIcon from '@material-ui/icons/KeyboardBackspaceOutlined';

import DiverstPagination from 'components/Shared/DiverstPagination';
import DiverstLoader from 'components/Shared/DiverstLoader';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

const styles = theme => ({
  floatRight: {
    float: 'right',
    marginBottom: 24,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
  buttonIcon: {
    paddingRight: 4,
  }
});

export function OutcomesList(props, context) {
  const { classes, intl } = props;

  return (
    <React.Fragment>
      <Grid container spacing={2} justify='space-between'>
        <Grid item>
          <Button
            variant='contained'
            to={props.links.eventIndex}
            color='secondary'
            size='medium'
            component={WrappedNavLink}
            startIcon={<BackIcon />}
          >
            <DiverstFormattedMessage {...messages.return} />
          </Button>
        </Grid>
        <Grid item>
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
        </Grid>
      </Grid>
      <DiverstLoader isLoading={props.isLoading}>
        <Grid container>
          { /* eslint-disable-next-line arrow-body-style */}
          {props.outcomes && props.outcomes.map((outcome, i) => (
            <Grid item key={outcome.id} xs={12}>
              <Card>
                <CardContent>
                  <Typography
                    color='primary'
                    variant='h6'
                    gutterBottom
                  >
                    {outcome.name}
                  </Typography>
                  <Box mb={1} mt={2}>
                    <Typography color='secondary'>
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
                      <DiverstFormattedMessage {...messages.pillars.empty} />
                    </Typography>
                  )}
                </CardContent>
                <CardActions>
                  <Button
                    component={WrappedNavLink}
                    color='primary'
                    to={props.links.outcomeEdit(outcome.id)}
                  >
                    Edit
                  </Button>
                  <Button
                    className={classes.errorButton}
                    onClick={() => {
                      /* eslint-disable-next-line no-alert, no-restricted-globals */
                      if (confirm('Delete outcome?'))
                        props.deleteOutcomeBegin(outcome);
                    }}
                  >
                    Delete
                  </Button>
                </CardActions>
              </Card>
              <Box mb={3} />
            </Grid>
          ))}
          {props.outcomes && props.outcomes.length <= 0 && (
            <React.Fragment>
              <Grid item sm>
                <Box mt={3} />
                <Typography variant='h6' align='center' color='textSecondary'>
                  <DiverstFormattedMessage {...messages.empty} />
                </Typography>
              </Grid>
            </React.Fragment>
          )}
        </Grid>
      </DiverstLoader>
      <DiverstPagination
        isLoading={props.isLoading}
        rowsPerPage={props.defaultParams.count}
        count={props.outcomesTotal}
        handlePagination={props.handlePagination}
      />
    </React.Fragment>
  );
}

OutcomesList.propTypes = {
  intl: PropTypes.object,
  classes: PropTypes.object,
  outcomes: PropTypes.array,
  outcomesTotal: PropTypes.number,
  isLoading: PropTypes.bool,
  defaultParams: PropTypes.object,
  handlePagination: PropTypes.func,
  links: PropTypes.object,
  deleteOutcomeBegin: PropTypes.func.isRequired,
};

export default compose(
  memo,
  withStyles(styles)
)(OutcomesList);
