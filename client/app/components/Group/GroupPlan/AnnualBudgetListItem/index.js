/**
 *
 * AnnualBudget List Item Component
 *
 */

import React, { memo } from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { lighten, makeStyles, withStyles } from '@material-ui/core/styles';
import { floatRound, percent } from 'utils/floatRound';

import {
  Box, Grid, Typography, Divider, Card, CardContent, LinearProgress, CardHeader, Button, Link
} from '@material-ui/core';

import KeyboardArrowRightIcon from '@material-ui/icons/KeyboardArrowRight';

import { formatDateTimeString, DateTime } from 'utils/dateTimeHelpers';
import WrappedNavLink from 'components/Shared/WrappedNavLink';

const styles = theme => ({
  arrowRight: {
    color: theme.custom.colors.grey,
  },
  divider: {
    color: theme.custom.colors.lightGrey,
    backgroundColor: theme.custom.colors.lightGrey,
    border: 'none',
    height: '1px',
  },
  dateText: {
    fontWeight: 'bold',
  },
});

const BorderLinearProgress = withStyles({
  root: {
    height: 7,
    backgroundColor: '#eee',
    borderRadius: 1000,
  },
  bar: {
    borderRadius: 1000,
  }
})(LinearProgress);

const RoundedBox = withStyles({
  root: {
    borderRadius: 1000,
  },
})(Box);

export function AnnualBudgetListItem(props) {
  const { classes, item } = props;
  const { expenses, amount, available, approved, remaining } = item;

  return (
    <Card>
      <CardContent>
        <Typography variant='h5' align='left' color='primary'>
          {item.closed ? 'Past Annual Budget' : 'Current Annual Budget'}
        </Typography>
        <Box mb={2} />
        <Grid
          alignItems='flex-start'
          justify='flex-start'
          container
          spacing={1}
        >
          <Grid item>
            <Typography variant='body1' component='h2'>
              Budgets
            </Typography>
          </Grid>
          <Grid item>
            <Divider orientation='vertical' />
          </Grid>
          <Grid item>
            <Link
              className={classes.eventLink}
              component={WrappedNavLink}
              to={{
                pathname: props.links.budgetsIndex(item.id),
                annualBudget: item
              }}
            >
              <Typography color='primary' variant='body1' component='h2'>
                View Budget Requests
              </Typography>
            </Link>
          </Grid>
          { item.closed || (
            <React.Fragment>
              <Grid item>
                <Divider orientation='vertical' />
              </Grid>
              <Grid item>
                <Link
                  className={classes.eventLink}
                  component={WrappedNavLink}
                  to={{
                    pathname: props.links.newRequest(item.id),
                    annualBudget: item
                  }}
                >
                  <Typography color='primary' variant='body1' component='h2'>
                    Create Budget Request
                  </Typography>
                </Link>
              </Grid>
            </React.Fragment>
          )}
        </Grid>
        <Grid
          alignItems='center'
          justify='center'
          container
          spacing={1}
        >
          <Grid item xs={1}>
            <Typography color='primary' variant='body1' component='h2'>
              Expenses
            </Typography>
            <Typography color='secondary' variant='body2' component='h2'>
              {`$${floatRound(expenses, 2)}`}
            </Typography>
          </Grid>
          <Grid item xs={10}>
            <RoundedBox boxShadow={1}>
              <BorderLinearProgress
                variant='buffer'
                value={percent(expenses, amount)}
                valueBuffer={percent(available, amount)}
              />
            </RoundedBox>
          </Grid>
          <Grid item xs={1}>
            <Typography color='primary' variant='body1' component='h2' align='right'>
              Annual Budget
            </Typography>
            <Typography color='secondary' variant='body2' component='h2' align='right'>
              {`$${floatRound(amount, 2)}`}
            </Typography>
          </Grid>
        </Grid>
        <Box mb={3} />
        <Grid container>
          <Grid item xs={4}>
            <Typography color='primary' variant='body1' component='h2' align='center'>
              Annual Budget
            </Typography>
          </Grid>
          <Grid item xs={4}>
            <Typography color='primary' variant='body1' component='h2' align='center'>
              Approved budget
            </Typography>
          </Grid>
          <Grid item xs={4}>
            <Typography color='primary' variant='body1' component='h2' align='center'>
              Available budget
            </Typography>
          </Grid>
        </Grid>
        <Divider />
        <Grid container>
          <Grid item xs={4}>
            <Typography color='secondary' variant='body2' component='h2' align='center'>
              {`$${floatRound(amount, 2)}`}
            </Typography>
          </Grid>
          <Grid item xs={4}>
            <Typography color='secondary' variant='body2' component='h2' align='center'>
              {`$${floatRound(approved, 2)}`}
            </Typography>
          </Grid>
          <Grid item xs={4}>
            <Typography color='secondary' variant='body2' component='h2' align='center'>
              {`$${floatRound(available, 2)}`}
            </Typography>
          </Grid>
        </Grid>
      </CardContent>
    </Card>
  );
}

AnnualBudgetListItem.propTypes = {
  classes: PropTypes.object,
  item: PropTypes.object,
  links: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(AnnualBudgetListItem);
