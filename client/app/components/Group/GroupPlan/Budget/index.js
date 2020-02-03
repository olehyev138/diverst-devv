/**
 *
 * AnnualBudget List Item Component
 *
 */

import React, { memo } from 'react';
import dig from 'object-dig';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { lighten, makeStyles, withStyles } from '@material-ui/core/styles';
import { floatRound, percent } from 'utils/floatRound';

import {
  Box,
  Grid,
  Typography,
  Divider,
  Card,
  CardContent,
  LinearProgress,
  CardHeader,
  Button,
  Link,
  DialogTitle,
  DialogContent, DialogContentText, TextField, DialogActions, Dialog
} from '@material-ui/core';

import KeyboardArrowRightIcon from '@material-ui/icons/KeyboardArrowRight';

import { formatDateTimeString, DateTime } from 'utils/dateTimeHelpers';
import DiverstTable from 'components/Shared/DiverstTable';
import { useFormik } from 'formik';
import DiverstSubmit from 'components/Shared/DiverstSubmit';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import ArrowBackIcon from '@material-ui/icons/ArrowBack';

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
  const { classes, budget, approveAction, declineAction, isCommitting, links } = props;
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
      title: 'Available Amount',
      field: 'available_amount',
      query_field: 'budget_items.available_amount',
      render: rowData => rowData.available_amount ? `$${floatRound(rowData.available_amount, 2)}` : '$0.00',
    },
    {
      title: 'Date',
      field: 'estimated_date',
      query_field: 'budget_items.estimated_date',
      render: rowData => rowData.estimated_date ? formatDateTimeString(rowData.estimated_date, DateTime.DATE_MED) : 'Not Set'
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

  const [formOpen, setFormOpen] = React.useState(false);

  const formik = useFormik({
    initialValues: {
      decline_reason: '',
    },
    onSubmit: (values) => {
      declineAction({ id: dig(budget, 'id'), ...values });
      handleFormClose();
    },
  });

  const handleFormClickOpen = () => {
    setFormOpen(true);
  };

  const handleFormClose = () => {
    setFormOpen(false);
  };

  const rejectDialog = (
    <Dialog open={formOpen} onClose={handleFormClose} aria-labelledby='form-dialog-title'>
      <form onSubmit={formik.handleSubmit}>
        <DialogTitle id='form-dialog-title'>
          Mentorship Request
        </DialogTitle>
        <DialogContent>
          <DialogContentText>
            Reason for declining budget request (Optional)
          </DialogContentText>

          <TextField
            autoFocus
            fullWidth
            margin='dense'
            id='decline_reason'
            name='decline_reason'
            type='text'
            onChange={formik.handleChange}
            value={formik.values.decline_reason}
          />
        </DialogContent>
        <DialogActions>
          <Button
            onClick={() => handleFormClose()}
            color='primary'
          >
            Cancel
          </Button>
          <DiverstSubmit isCommitting={isCommitting}>
            Submit
          </DiverstSubmit>
        </DialogActions>
      </form>
    </Dialog>
  );

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
                  onClick={() => approveAction({ id: dig(budget, 'id') })}
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
                  onClick={handleFormClickOpen}
                >
                  <Typography variant='h6' component='h2'>
                    Decline
                  </Typography>
                </Button>
              </Grid>
            </Grid>
            { rejectDialog }
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
                  {declineReason || 'Non Given'}
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
        <Grid
          container
          alignContent='space-between'
          spacing={2}
          alignItems='flex-end'
          justify='flex-end'
        >
          <Grid item xs>
            <Typography variant='h4' component='h2'>
              Budget Details
            </Typography>
          </Grid>
          <Grid item xs align='right'>
            <Button
              color='primary'
              variant='contained'
              startIcon={<ArrowBackIcon />}
              component={WrappedNavLink}
              to={links.back}
            >
              Back to Annual Budget
            </Button>
          </Grid>
        </Grid>
        <Box mb={2} />
        <Card>
          <CardContent>
            <Typography variant='h6' component='h2'>
              Budget Details
            </Typography>
            <Box mb={1} />
            <Typography variant='body1' component='h3' color='secondary'>
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

  isCommitting: PropTypes.bool,

  approveAction: PropTypes.func,
  declineAction: PropTypes.func,
};

export default compose(
  memo,
  withStyles(styles),
)(Budget);
