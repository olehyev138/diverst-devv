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
import messages from 'containers/Group/GroupPlan/BudgetItem/messages';
import { injectIntl, intlShape } from 'react-intl';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';

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
import DeleteIcon from '@material-ui/icons/DeleteOutline';
import CloseIcon from '@material-ui/icons/Close';

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
  const { classes, budget, approveAction, declineAction, isCommitting, links, intl } = props;
  const { description, is_approved: isApproved, decline_reason: declineReason, budget_items: budgetItems } = (budget || {});

  const columns = [
    {
      title: intl.formatMessage(messages.columns.status),
      field: 'is_done',
      query_field: 'budget_items.is_done',
      lookup: {
        false: intl.formatMessage(messages.lookup.isDoneFalse),
        true: intl.formatMessage(messages.lookup.isDoneTrue),
      }
    },
    {
      title: intl.formatMessage(messages.columns.title),
      field: 'title',
      query_field: 'budget_items.title',
    },
    {
      title: intl.formatMessage(messages.columns.requested),
      field: 'estimated_amount',
      query_field: 'budget_items.estimated_amount',
      render: rowData => rowData.estimated_amount ? `$${floatRound(rowData.estimated_amount, 2)}` : '$0.00',
    },
    {
      title: intl.formatMessage(messages.columns.available),
      field: 'available_amount',
      query_field: 'budget_items.available_amount',
      render: rowData => rowData.available_amount ? `$${floatRound(rowData.available_amount, 2)}` : '$0.00',
    },
    {
      title: intl.formatMessage(messages.columns.endDate),
      field: 'estimated_date',
      query_field: 'budget_items.estimated_date',
      render: rowData => rowData.estimated_date
        ? formatDateTimeString(rowData.estimated_date, DateTime.DATE_MED)
        : intl.formatMessage(messages.lookup.notSet)
    },
    {
      title: intl.formatMessage(messages.columns.private),
      field: 'is_private',
      query_field: 'budget_items.is_private',
      lookup: {
        false: intl.formatMessage(messages.lookup.privateTrue),
        true: intl.formatMessage(messages.lookup.privateFalse),
      }
    },
  ];

  const actions = [];

  actions.push(rowData => ({
    icon: () => <CloseIcon />,
    tooltip: <DiverstFormattedMessage {...messages.actions.close} />,
    onClick: (_, rowData) => {
      // eslint-disable-next-line no-restricted-globals,no-alert
      if (confirm(intl.formatMessage(messages.actions.closeConfirm)))
        props.closeBudgetAction({ id: rowData.id });
    },
    disabled: rowData.is_done,
  }));

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
        <DialogContent>
          <DialogContentText>
            <DiverstFormattedMessage {...messages.declineForm.question} />
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
            <DiverstFormattedMessage {...messages.declineForm.cancel} />
          </Button>
          <DiverstSubmit isCommitting={isCommitting}>
            <DiverstFormattedMessage {...messages.declineForm.submit} />
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
                    <DiverstFormattedMessage {...messages.buttons.approve} />
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
                    <DiverstFormattedMessage {...messages.buttons.decline} />
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
                  <DiverstFormattedMessage {...messages.declineReason} />
                </Typography>
                <Typography variant='body1' component='h2' color='secondary'>
                  {declineReason || <DiverstFormattedMessage {...messages.defaultReason} />}
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
              <DiverstFormattedMessage {...messages.title} />
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
              <DiverstFormattedMessage {...messages.buttons.back} />
            </Button>
          </Grid>
        </Grid>
        <Box mb={2} />
        <Card>
          <CardContent>
            <Typography variant='h6' component='h2'>
              <DiverstFormattedMessage {...messages.description} />
            </Typography>
            <Box mb={1} />
            <Typography variant='body1' component='h3' color='secondary'>
              {description}
            </Typography>
          </CardContent>
        </Card>
        <Box mb={2} />
        <DiverstTable
          title={<DiverstFormattedMessage {...messages.tableTitle} />}
          dataArray={budgetItems}
          dataTotal={(budgetItems || []).length}
          columns={columns}
          actions={actions}
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
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  budget: PropTypes.object,
  links: PropTypes.object,

  isCommitting: PropTypes.bool,

  approveAction: PropTypes.func.isRequired,
  declineAction: PropTypes.func.isRequired,
  closeBudgetAction: PropTypes.func.isRequired,
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(Budget);
