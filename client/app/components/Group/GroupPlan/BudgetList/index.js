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
      title: intl.formatMessage(messages.columns.requested),
      field: 'requested_amount',
      sorting: false,
      render: rowData => rowData.requested_amount ? `$${floatRound(rowData.requested_amount, 2)}` : '$0.00',
    },
    {
      title: intl.formatMessage(messages.columns.available),
      field: 'available_amount',
      sorting: false,
      render: rowData => rowData.available_amount ? `$${floatRound(rowData.available_amount, 2)}` : '$0.00',
    },
    {
      title: intl.formatMessage(messages.columns.status),
      field: 'status',
      sorting: false,
    },
    {
      title: intl.formatMessage(messages.columns.requestedAt),
      field: 'requested_at',
      query_field: 'created_at',
      render: rowData => formatDateTimeString(rowData.requested_at, DateTime.DATETIME_MED)
    },
    {
      title: intl.formatMessage(messages.columns.number),
      field: 'item_count',
      sorting: false,
    },
    {
      title: intl.formatMessage(messages.columns.description),
      field: 'description',
      query_field: 'description',
    },
  ];

  const actions = [];

  actions.push({
    icon: () => <DetailsIcon />,
    tooltip: <DiverstFormattedMessage {...messages.actions.details} />,
    onClick: (_, rowData) => {
      // eslint-disable-next-line no-alert
      props.handleVisitBudgetShow(props.currentGroup.id, props.annualBudget.id, rowData.id);
    }
  });

  actions.push({
    icon: () => <DeleteIcon />,
    tooltip: <DiverstFormattedMessage {...messages.actions.delete} />,
    onClick: (_, rowData) => {
      // eslint-disable-next-line no-alert
      props.deleteBudgetBegin({ id: rowData.id });
    }
  });

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
        </Grid>
      </CardContent>
      <Grid container spacing={3}>
        <Grid item xs>
          <DiverstTable
            title={intl.formatMessage(messages.tableTitle)}
            handlePagination={props.handlePagination}
            onOrderChange={handleOrderChange}
            isLoading={props.isFetchingBudgets}
            rowsPerPage={5}
            dataArray={Object.values(props.budgets)}
            dataTotal={props.budgetTotal}
            columns={columns}
            actions={actions}
            my_options={{
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
  })
};

export default compose(
  memo,
  withStyles(styles),
  injectIntl,
)(BudgetList);
