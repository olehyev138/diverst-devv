/**
 *
 * BudgetList Component
 *
 *
 */

import React, {
  memo
} from 'react';
import PropTypes from 'prop-types';
import { compose } from 'redux';
import { floatRound } from 'utils/floatRound';

import {
  Button, Card, CardContent, CardActions,
  Typography, Grid, Link, TablePagination, Collapse, Box, MenuItem,
} from '@material-ui/core';
import { withStyles } from '@material-ui/core/styles';

import DeleteIcon from '@material-ui/icons/DeleteOutline';
import DetailsIcon from '@material-ui/icons/Details';

import DiverstTable from 'components/Shared/DiverstTable';
import { DateTime, formatDateTimeString } from 'utils/dateTimeHelpers';
import WrappedNavLink from 'components/Shared/WrappedNavLink';
import DiverstFormattedMessage from 'components/Shared/DiverstFormattedMessage';
import messages from 'containers/Group/GroupPlan/Budget/messages';

import ArrowBackIcon from '@material-ui/icons/ArrowBack';
import AddIcon from '@material-ui/icons/Add';
import { injectIntl, intlShape } from 'react-intl';
import { toCurrencyString } from 'utils/currencyHelpers';
import { permission } from 'utils/permissionsHelpers';
import Permission from 'components/Shared/DiverstPermission';

const styles = theme => ({
  budgetListItem: {
    width: '100%',
  },
  budgetListItemDescription: {
    paddingTop: 8,
  },
  errorButton: {
    color: theme.palette.error.main,
  },
});

export function BudgetList(props, context) {
  const { classes, intl } = props;

  const handleOrderChange = (columnId, orderDir) => {
    props.handleOrdering({
      orderBy: (columnId === -1) ? 'id' : `${columns[columnId].query_field}`,
      orderDir: (columnId === -1) ? 'asc' : orderDir
    });
  };

  const columns = [
    {
      title: intl.formatMessage(messages.columns.requested, props.customTexts),
      field: 'requested_amount',
      sorting: false,
      render: rowData => toCurrencyString(props.intl, rowData.requested_amount || 0, rowData.currency),
    },
    {
      title: intl.formatMessage(messages.columns.available, props.customTexts),
      field: 'available',
      sorting: false,
      render: rowData => toCurrencyString(props.intl, rowData.available || 0, rowData.currency),
    },
    {
      title: intl.formatMessage(messages.columns.status, props.customTexts),
      field: 'status',
      sorting: false,
    },
    {
      title: intl.formatMessage(messages.columns.requestedAt, props.customTexts),
      field: 'requested_at',
      query_field: 'created_at',
      render: rowData => formatDateTimeString(rowData.requested_at, DateTime.DATETIME_MED)
    },
    {
      title: intl.formatMessage(messages.columns.number, props.customTexts),
      field: 'item_count',
      sorting: false,
    },
    {
      title: intl.formatMessage(messages.columns.description, props.customTexts),
      field: 'description',
      query_field: 'description',
    },
  ];

  const actions = [];

  actions.push({
    icon: () => <DetailsIcon />,
    tooltip: intl.formatMessage(messages.actions.details, props.customTexts),
    onClick: (_, rowData) => {
      // eslint-disable-next-line no-alert
      props.handleVisitBudgetShow(props.currentGroup.id, props.annualBudget.id, rowData.id);
    }
  });

  actions.push(rowData => ({
    icon: () => <DeleteIcon />,
    tooltip: intl.formatMessage(messages.actions.delete, props.customTexts),
    disabled: !permission(rowData, 'destroy?'),
    onClick: (_, rowData) => {
      // eslint-disable-next-line no-alert,no-restricted-globals
      if (confirm(intl.formatMessage(messages.actions.deleteConfirmation)))
        props.deleteBudgetBegin({ id: rowData.id });
    }
  }));

  return (
    <React.Fragment>
      <CardContent>
        <Grid
          container
          alignContent='space-between'
          spacing={2}
          alignItems='flex-end'
          justify='flex-end'
        >
          <Grid item xs>
            <Button
              color='primary'
              variant='contained'
              to={props.links.annualBudgetOverview}
              component={WrappedNavLink}
              startIcon={<ArrowBackIcon />}
            >
              <DiverstFormattedMessage {...messages.buttons.back} />
            </Button>
          </Grid>
          <Permission show={permission(props.currentGroup, 'budgets_create?') && !props.annualBudget?.closed}>
            <Grid item xs align='right'>
              <Button
                color='primary'
                variant={props.annualBudget && !props.annualBudget.closed ? 'contained' : 'disabled'}
                to={props.links.newRequest}
                component={WrappedNavLink}
                startIcon={<AddIcon />}
              >
                <DiverstFormattedMessage {...messages.buttons.new} />
              </Button>
            </Grid>
          </Permission>
        </Grid>
      </CardContent>
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={messages.tableTitle}
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.isFetchingBudgets}
            rowsPerPage={5}
            dataArray={props.budgets}
            dataTotal={props.budgetTotal}
            columns={columns}
            actions={actions}
            tableOptions={{
              search: false,
            }}
          />
        </Grid>
      </Grid>
    </React.Fragment>
  );
}

BudgetList.propTypes = {
  intl: intlShape.isRequired,
  classes: PropTypes.object,
  annualBudget: PropTypes.object,
  currentGroup: PropTypes.object,
  budgets: PropTypes.array,
  budgetTotal: PropTypes.number,
  isFetchingBudgets: PropTypes.bool,
  deleteBudgetBegin: PropTypes.func,
  handlePagination: PropTypes.func,
  handleOrdering: PropTypes.func,
  handleVisitBudgetEdit: PropTypes.func,
  handleChangeScope: PropTypes.func,
  budgetType: PropTypes.string,
  handleVisitBudgetShow: PropTypes.func,
  links: PropTypes.shape({
    newRequest: PropTypes.string,
    annualBudgetOverview: PropTypes.string,
    requestDetails: PropTypes.func
  }),
  customTexts: PropTypes.object
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(BudgetList);
