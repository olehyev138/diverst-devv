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
import DiverstTable from 'components/Shared/DiverstTable';

const styles = theme => ({
  arrowRight: {
    color: theme.custom.colors.grey,
  },
  errorButton: {
    color: theme.palette.error.main,
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

export function Budget(props) {
  const { classes, budget } = props;
  const { description, is_approved: isApproved, decline_reason: declineReason, budget_items: budgetItems } = (budget || {});

  const columns = [
    {
      title: 'Status',
      field: 'is_done',
      query_field: 'budget_items.is_done',
      lookup: {
        false: 'Available',
        true: 'Used',
      }
    },
    {
      title: 'Title',
      field: 'title',
      query_field: 'budget_items.title',
    },
    {
      title: 'Requested Amount',
      field: 'estimated_amount',
      query_field: 'budget_items.estimated_amount',
      render: rowData => rowData.estimated_amount ? `$${floatRound(rowData.estimated_amount, 2)}` : '$0.00',
    },
    {
      title: 'Date',
      field: 'estimated_date',
      query_field: 'budget_items.estimated_date',
      render: rowData => rowData.estimated_date ? formatDateTimeString(rowData.estimated_date, DateTime.DATETIME_MED) : 'Not Set'
    },
    {
      title: 'Private',
      field: 'is_private',
      query_field: 'budget_items.is_private',
      lookup: {
        false: 'No',
        true: 'Yes',
      }
    },
  ];

  const footer = () => {
    switch (isApproved) {
      case null:
        return (
          <React.Fragment>
            <Box mb={2} />
            <Grid container spacing={3}>
              <Grid item>
                <Button
                  color='primary'
                  variant='contained'
                  onClick={() => {
                    // eslint-disable-next-line no-alert
                    alert('Not Implemented Yet');
                  }}
                >
                  <Typography variant='h6' component='h2'>
                    Approve
                  </Typography>
                </Button>
              </Grid>
              <Grid item>
                <Button
                  className={classes.errorButton}
                  variant='contained'
                  onClick={() => {
                    // eslint-disable-next-line no-alert
                    alert('Not Implemented Yet');
                  }}
                >
                  <Typography variant='h6' component='h2'>
                    Decline
                  </Typography>
                </Button>
              </Grid>
            </Grid>
          </React.Fragment>
        );
      case false:
        return (
          <React.Fragment>
            <Box mb={2} />
            <Card>
              <CardContent>
                <Typography variant='h6' component='h2'>
                  Reason why this request was declined
                </Typography>
                <Typography variant='body1' component='h2' color='secondary'>
                  {description}
                </Typography>
              </CardContent>
            </Card>
          </React.Fragment>
        );
      default:
        return <React.Fragment />;
    }
  };

  return (
    budget && (
      <React.Fragment>
        <Typography variant='h4' component='h2'>
          Budget Details
        </Typography>
        <Box mb={2} />
        <Card>
          <CardHeader
            title='Description'
          />
          <CardContent>
            <Typography variant='body1' component='h2'>
              {description}
            </Typography>
          </CardContent>
        </Card>
        <Box mb={2} />
        <DiverstTable
          title='Events'
          dataArray={budgetItems}
          dataTotal={(budgetItems || []).length}
          columns={columns}
          handlePagination={() => null}
          handleOrdering={() => null}
          rowsPerPage={Math.min((budgetItems || []).length, 5)}
          my_options={{
            search: false
          }}
        />
        {footer()}
      </React.Fragment>
    )
  );
}

Budget.propTypes = {
  classes: PropTypes.object,
  budget: PropTypes.object,
  links: PropTypes.object,
};

export default compose(
  memo,
  withStyles(styles),
)(Budget);
